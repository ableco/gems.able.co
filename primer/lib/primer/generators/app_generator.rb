require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Primer
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: "-d", default: "postgresql",
      desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :heroku, type: :boolean, aliases: "-H", default: false,
      desc: "Create staging and production Heroku apps"

    class_option :heroku_flags, type: :string, default: "",
      desc: "Set extra Heroku flags"

    class_option :github, type: :string, aliases: "-G", default: nil,
      desc: "Create Github repository and add remote origin pointed to repo"

    class_option :skip_test_unit, type: :boolean, aliases: "-T", default: true,
      desc: "Skip Test::Unit files"

    class_option :skip_turbolinks, type: :boolean, default: true,
      desc: "Skip turbolinks gem"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    def finish_template
      invoke :primer_customization
      super
    end

    def primer_customization
      invoke :customize_gemfile
      invoke :setup_template_view_structure
      invoke :configure_generators
      invoke :setup_test_environment
      # invoke :configure_react
    end

    def customize_gemfile
      build :set_ruby_to_version_being_used
      bundle_command 'install'
    end

    def setup_template_view_structure
      say "Setting up template/view structure"
      build :create_templates_directory
      build :remove_layout_from_views
      build :support_templates_and_views_in_application_rb
    end

    def configure_generators
      say "Configuring generators"
      build :configure_generators
    end

    def setup_test_environment
      say "Setting up test environment"
      build :setup_factory_girl_for_rspec
      build :generate_rspec
      build :configure_rspec
      build :configure_database_cleaner_in_specs
      build :configure_shoulda_matchers_in_specs
      build :configure_action_mailer_in_specs
      build :configure_simple_cov_in_specs
      build :setup_default_rspec_directories
    end

    def setup_react
      say "Setting up React"
      # TODO
    end

    # def setup_flux? redux?
    #   say "Setting up React"
    #   # TODO
    # end

    protected

    def get_builder_class
      Primer::AppBuilder
    end
  end
end
