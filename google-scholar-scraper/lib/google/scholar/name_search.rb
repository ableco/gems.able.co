require 'google/scholar/search'

module Google
  module Scholar
    class NameSearch < Google::Scholar::Search
      def initialize(full_name)
        raise "Needs a valid name" if full_name.nil?
        name = full_name.downcase.gsub(" ", "+")
        @path = "/scholar?as_q=&as_sauthors=%22#{name}%22"
      end

      def parse(page, articles_arr)
        articles_wrap = page.css('div.gs_ri')
        if articles_wrap.count > 0
          articles_wrap.each do |article|
            h3 = article.css('h3').first
            title = h3.text
            href = h3.children.first.attributes["href"]
            link = href.nil? ? nil : href.value
            desc_wrap = article.css('div.gs_rs').first
            desc = desc_wrap.nil? ? nil : desc_wrap.children.text
            y = article.css('div.gs_a')
            year = y.children.first.text.scan(/\d+/).first
            articles_arr << Google::Scholar::Scraper::Article.new(title, link, desc, year)
          end
        end
      end
    end
  end
end
