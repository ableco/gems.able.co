require "rails/generators"
require "deep_merge/rails_compat"
require "yaml"

module Ablecop
  # Public: `rails generate ablecop install`.
  class InstallGenerator < Rails::Generators::Base
    # The key in this hash is the filename located under the config/
    # directory in the root of the gem, and the value is the destination
    # we want to copy the file to.
    CONFIGURATION_FILES = {
      ".fasterer.yml"            => ".",
      ".rubocop.yml"             => ".",
      ".scss-lint.yml"           => ".",
      "rails_best_practices.yml" => "config"
    }.freeze

    source_root File.expand_path("../../../../config", __FILE__)

    desc "Copy the ablecop config files to the application's root folder."

    # Public: When we run the install generator, we copy the config files from
    # the gem to the application.
    #
    # By copying our config files to the application's folder, developer's
    # can take advantage of linters that run in their editor for realtime
    # feedback as they're developing.
    def copy_config_files
      CONFIGURATION_FILES.each do |file_name, destination|
        ensure_config_file!(file_name, destination)
      end

      add_files_to_gitignore
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
    def ensure_config_file!(file_name, destination)
      default_config_file = File.expand_path("../../../../config/#{file_name}", __FILE__)
      application_config_file = File.expand_path("#{destination}/#{file_name}", destination_root)
      override_config_file = File.expand_path("config/ablecop/#{file_name}", destination_root)

      # If an override exists, merge it.
      if File.exist?(override_config_file)
        create_file(application_config_file, merge_override_config(default_config_file, override_config_file))
      else
        copy_file(default_config_file, application_config_file)
      end

      raise ConfigFileError, "Required config file #{file_name} missing" unless File.exist?(application_config_file)
    end

    # Internal: Check if the configuration files in the supplied array is
    # already in the application's .gitignore file, and add the file names
    # that do not exist.
    #
    # configuration_files - Array of strings of the configuration file
    #                       names we want to include in .gitignore.
    #
    # Examples
    #
    #   # rubocop
    #   add_to_gitignore(["rubocop.yml", "fasterer.yml", "scss-lint.yml"])
    #
    # Returns nil.
    def add_files_to_gitignore
      gitignore_file = File.expand_path(".gitignore", destination_root)
      create_file(".gitignore") unless File.exist?(gitignore_file)

      files_to_add = CONFIGURATION_FILES.map do |file_name, destination|
        "#{destination}/#{file_name}".gsub("./", "")
      end

      files_to_add.reject! do |file_name|
        File.readlines(gitignore_file).any? { |line| line.strip == file_name }
      end

      return if files_to_add.empty?

      append_to_file(gitignore_file, files_to_add.join("\n"))
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
