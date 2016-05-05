require "ablecop"
require "rails"

module Ablecop
  # :NODOC:
  class Railtie < Rails::Railtie
    railtie_name :ablecop

    # Public: Expose our rake tasks to the Rails application.
    rake_tasks do
      load "ablecop/tasks/ablecop.rake"
    end

    # Public: Expose generators to application's `rails generate`.
    generators do
      require "ablecop/generators/install_generator"
    end
  end
end
