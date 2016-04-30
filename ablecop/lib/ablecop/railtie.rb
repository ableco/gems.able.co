require "ablecop"
require "rails"
require "deep_merge/rails_compat"

module Ablecop
  # :NODOC:
  class Railtie < Rails::Railtie
    railtie_name :ablecop

    # Public: When Rails initializes, we check to make sure that the config
    # files we expect to be in the application folder. If they're not in the
    # application's root folder, we copy them from the gem to the application.
    #
    # By copying our config files to the application's folder, developer's
    # can take advantage of linters that run in their editor for realtime
    # feedback as they're developing.
    initializer "ablecop.initialize" do
      ensure_config_file!("fasterer.yml")
      ensure_config_file!("rubocop.yml")
      ensure_config_file!("scss-lint.yml")
    end

    # Expose our rake tasks to the Rails application.
    rake_tasks do
      load "ablecop/tasks/ablecop.rake"
    end

    private

    # Internal: Error returned if we can't find or create the config file.
    class ConfigFileError < RuntimeError
    end

    # Internal: Ensure that we have a configuration file for the runners
    # that we will include in the gem. If a configuration file with the same
    # name exists in the `config/ablecop` directory of the application,
    # we'll merge the override configuration file to our default configuration.
    # If no configuration file exists in that directory, check if the application's
    # directory already has our default configuration and copy it over if it
    # does not exist.
    #
    # file_name - String file name of the config file we want to ensure.
    #
    # Examples
    #
    #   # rubocop
    #   ensure_config_file!("rubocop.yml")
    #
    #   # scss-lint
    #   ensure_config_file!("scss-lint.yml")
    #
    # Returns nil or a ConfigFileError if the process fails.
    def ensure_config_file!(file_name)
      default_config_file = File.expand_path("../../../config/#{file_name}", __FILE__)
      application_config_file = File.expand_path(".#{file_name}", Rails.root)
      override_config_file = File.expand_path("config/ablecop/#{file_name}", Rails.root)

      # if an override exists, merge it
      if File.exists?(override_config_file)
        default_config = YAML.load_file(default_config_file)
        application_config = YAML.load_file(application_config_file)
        override_config = YAML.load_file(override_config_file)

        default_config.ko_deeper_merge!(override_config)
        return if default_config == application_config
        File.open(application_config_file, "w") { |f| f.write(default_config.to_yaml) }
      else
        return if application_config_file_matches_default?(application_config_file, default_config_file)
        FileUtils.copy_file(default_config_file, application_config_file)
      end

      raise ConfigFileError, "Required config file .#{file_name} missing" unless File.exists?(application_config_file)
    end

    # Internal: Check to see if the config file in the application's root
    # matches the default config file.
    #
    # application_config_file - Application config file path to check.
    # default_config_file - Default config file path to check.
    #
    # Returns Boolean, true if the default file matches the application's.
    def application_config_file_matches_default?(application_config_file, default_config_file)
      File.exist?(application_config_file) && FileUtils.compare_file(application_config_file, default_config_file)
    end
  end
end
