require "rails/generators"
require "deep_merge/rails_compat"
require "yaml"

module Ablecop
  # Public: `rails generate ablecop install`.
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../../config", __FILE__)

    desc "Copy the ablecop config files to the application's root folder."

    # Public: When we run the install generator, we copy the config files from
    # the gem to the application.
    #
    # By copying our config files to the application's folder, developer's
    # can take advantage of linters that run in their editor for realtime
    # feedback as they're developing.
    def copy_config_files
      configuration_files = %w(fasterer.yml rubocop.yml scss-lint.yml)
      configuration_files.each do |file_name|
        ensure_config_file!(file_name)
        add_to_gitignore(file_name)
      end
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
      default_config_file = File.expand_path("../../../../config/#{file_name}", __FILE__)
      application_config_file = File.expand_path(".#{file_name}", destination_root)
      override_config_file = File.expand_path("config/ablecop/#{file_name}", destination_root)

      # If an override exists, merge it.
      if File.exist?(override_config_file)
        create_file(application_config_file, merge_override_config(default_config_file, override_config_file))
      else
        copy_file(default_config_file, application_config_file)
      end

      raise ConfigFileError, "Required config file .#{file_name} missing" unless File.exist?(application_config_file)
    end

    # Internal: Check if the config file is already in the application's
    # .gitignore file, and add it if it's not.
    #
    # file_name - String file name of the config file we want to include
    #             in .gitignore.
    #
    # Examples
    #
    #   # rubocop
    #   add_to_gitignore("rubocop.yml")
    #
    # Returns true if the config file was added to .gitignore.
    # Returns nil if the config file was already in .gitignore.
    def add_to_gitignore(file_name)
      gitignore_file = File.expand_path(".gitignore", destination_root)
      create_file(".gitignore") unless File.exist?(gitignore_file)
      unless File.readlines(gitignore_file).any? { |line| line.strip == ".#{file_name}" }
        append_to_file(gitignore_file, ".#{file_name}")
        return true
      end
    end

    # Internal: Merge the contents of the override configuration file
    # in YAML format with the contents of the default.
    #
    # default - The default configuration file in the Ablecop gem
    #           (under config/).
    # override - The override configuration file in the application
    #            directory (under config/ablecop in the application's
    #            root)
    #
    # Examples
    #
    #   # Rubocop
    #
    #   default_config_file = File.expand_path("../../../../config/#{file_name}", __FILE__)
    #   override_config_file = File.expand_path("config/ablecop/#{file_name}", destination_root)
    #   merge_override_config(default_config_file, override_config_file)
    #
    # Returns a string of the merged configuration in YAML format.
    def merge_override_config(default, override)
      default_config = YAML.load_file(default)
      override_config = YAML.load_file(override)
      default_config.ko_deeper_merge!(override_config)
      default_config.to_yaml
    end
  end
end
