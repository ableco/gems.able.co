require 'nokogiri'
require 'open-uri'
require 'google/scholar/article'
require 'google/scholar/request'
require 'google/scholar/name_search'
require 'google/scholar/user_search'

module Google
  module Scholar
    class Scraper
      # Use
      # scraper = Google::Scholar::Scraper.new
      # scraper.scrape_page(path)
      # scraper.articles -> is an array of articles classes
      attr_accessor :articles, :last_request

      def initialize
        @articles = []
      end

      def scrape_page(path)
        # path => path to scrape inside scholar
        last_user_agent = @last_request.nil? ? nil : @last_request.user_agent
        request = Google::Scholar::Request.new(path, last_user_agent)
        @last_request = request
        page = request.send
      end
    end
  end
end
