module Google
  module Scholar
    class Search
      attr_accessor :path, :scraper

      def scrape
        @scraper = Google::Scholar::Scraper.new
        page = @scraper.scrape_page(@path)
        parse(page, @scraper.articles)
      end
    end
  end
end
