require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Primer
  class AppGenerator < Rails::Generators::AppGenerator
    def finish_template
      invoke :primer_customization
      super
    end

    def primer_customization
      # invoke :foo
    end

    def foo
      say 'Setting up foofoo'
      # build :foofoo
    end

    protected

    def get_builder_class
      Primer::AppBuilder
    end
  end
end
