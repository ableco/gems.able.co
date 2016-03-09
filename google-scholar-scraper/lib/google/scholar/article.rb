module Google
  module Scholar
    class Article
      # Represent an article
      attr_accessor :title, :link, :description, :year

      def initialize (title, link, description, year)
        @title = title
        @link = link
        @description = description
        @year = year
      end
    end
  end
end
