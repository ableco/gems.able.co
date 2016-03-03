require 'nokogiri'
require 'open-uri'

module Google
  module Scholar
    class Article
      # Represent an article
      attr_accessor :title, :link, :desc, :year

      def initialize title, link, desc, year
       @title = title
       @link = link
       @desc = desc
       @year = year
      end
    end

    class Scraper
      # Use
      # scraper = Google::Scholar::Scraper.new some_name
      # scraper.articles -> is an array of articles classes
      attr_accessor :articles

      SCHOLAR_URL = "https://scholar.google.com"

      def initialize full_name
        raise "Needs a valid url" if full_name.nil?
        @articles = []

        name = full_name.downcase.gsub(" ", "+")
        path = "/scholar?as_q=&as_sauthors=%22#{name}%22"

        scrape_page path
      end

      def parse_articles page, articles_arr
        articles_wrap = page.css('div.gs_ri')
        if articles_wrap.count > 0
          articles_wrap.each do |article|
            h3 = article.css('h3').first
            title = h3.text
            href = h3.children.first.attributes["href"]
            link = href.nil? ? nil : href.value
            desc = article.css('div.gs_rs').first.children.text
            y = article.css('div.gs_a')
            year = y.children.first.text.scan(/\d+/).first
            articles_arr << Scholar::Article.new(title, link, desc, year)
          end
        end
      end

      def scrape_page(path, link_page=false)
        url = SCHOLAR_URL + path
        page = Nokogiri::HTML(open(url))
        parse_articles(page, @articles)

        if !link_page
          links = page.css('#gs_n a')

          links.each do |link|
            if link != links.last
              scrape_page(link.attributes["href"].text, true)
            end
          end
        end
      end
    end
  end
end
