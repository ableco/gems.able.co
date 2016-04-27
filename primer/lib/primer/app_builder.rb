require "forwardable"

module Primer
  class AppBuilder < Rails::AppBuilder
    include Primer::Actions
    extend Forwardable

    def gemfile
      template "Gemfile.erb", "Gemfile"
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
    end
        RUBY
      end
    end
  end
end
