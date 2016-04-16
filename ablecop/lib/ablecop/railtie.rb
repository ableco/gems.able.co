require "ablecop"
require "rails"

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

    # Internal: Make sure the given file_name exists in the application's
    # root folder. If it doesn't, copy the default config file to the root.
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
      application_config_file = File.expand_path(".#{file_name}", Rails.root)
      default_config_file = File.expand_path("../../../config/#{file_name}", __FILE__)
      return if application_config_file_matches_default?(application_config_file, default_config_file)

      FileUtils.copy_file(default_config_file, application_config_file)
      return if application_config_file_matches_default?(application_config_file, default_config_file)

      raise ConfigFileError, "Required config file .#{file_name} missing"
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
