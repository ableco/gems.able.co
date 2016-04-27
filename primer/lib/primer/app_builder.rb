require "forwardable"

module Primer
  class AppBuilder < Rails::AppBuilder
    include Primer::Actions
    extend Forwardable

    def gemfile
      template "Gemfile.erb", "Gemfile"
    end

    def foofoo

    end
  end
end
