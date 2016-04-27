require "forwardable"

module Primer
  class AppBuilder < Rails::AppBuilder
    include Primer::Actions
    extend Forwardable

    def gemfile
      template "Gemfile.erb", "Gemfile"
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Primer::RUBY_VERSION}\n"
    end

    def create_templates_directory
      directory 'app/views', 'app/templates'
    end

    def remove_layout_from_views
      remove_dir 'app/views/layouts'
    end

    def support_templates_and_views_in_application_rb
      inject_into_file "config/application.rb", after: "config.active_record.raise_in_transactional_callbacks = true\n" do
        <<-RUBY

    # Support /app/view .rb classes and /app/templates files.
    config.autoload_paths << (Rails.root + "app/views/concerns").to_s
    config.autoload_paths << (Rails.root + "app/views").to_s
    config.to_prepare do
      ApplicationController.send(:append_view_path, Rails.root.join("app", "templates"))
    end
        RUBY
      end
    end

    def configure_generators
      inject_into_file "config/application.rb", after: "config.active_record.raise_in_transactional_callbacks = true\n" do
        <<-RUBY

    # Don't generate helpers, assets, and view specs by default.
    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.erb false
      generate.view_specs false
      generate.test_framework :rspec
    end
        RUBY
      end
    end

    def setup_factory_girl_for_rspec
      copy_file 'factory_girl_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def configure_rspec
      remove_file "spec/rails_helper.rb"
      remove_file "spec/spec_helper.rb"
      copy_file "rails_helper.rb", "spec/rails_helper.rb"
      copy_file "spec_helper.rb", "spec/spec_helper.rb"
    end

    def configure_database_cleaner_in_specs
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def configure_shoulda_matchers_in_specs
      copy_file(
        "shoulda_matchers_rspec.rb",
        "spec/support/shoulda_matchers.rb"
      )
    end

    def configure_action_mailer_in_specs
      copy_file 'action_mailer_rspec.rb', 'spec/support/action_mailer.rb'
    end

    def configure_simple_cov_in_specs
      copy_file 'simple_cov_rspec.rb', 'spec/support/simple_cov.rb'
    end

    def setup_default_rspec_directories
      [
        'spec/cassettes',
        'spec/controllers',
        'spec/factories',
        'spec/lib',
        'spec/models',
        'spec/routing',
        'spec/views'
      ].each do |dir|
        empty_directory_with_keep_file dir
      end
    end
  end
end
