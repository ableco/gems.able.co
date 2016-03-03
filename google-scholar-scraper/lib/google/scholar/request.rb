module Google
  module Scholar
    class Request
      attr_accessor :user_agent, :time_sent

      SCHOLAR_URL = "https://scholar.google.com"
      USER_AGENTS = [
        "Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0",
        "Mozilla/5.0 (compatible; MSIE 9.0; AOL 9.7; AOLBuild 4343.19; Windows NT 6.1; WOW64; Trident/5.0; FunWebProducts)",
        "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
        "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; XH; rv:8.578.498) fr, Gecko/20121021 Camino/8.723+ (Firefox compatible)"
      ]

      def initialize(path=nil, last_user_agent=nil)
        @length = USER_AGENTS.length
        @url = path.nil? ? "": "#{SCHOLAR_URL + path}"
        
        (1..5).map do
          tmp_agent = get_user_agent
          if valid_agent?(tmp_agent, last_user_agent)
            self.user_agent = tmp_agent
            return
          end
        end
      end

      def get_user_agent
        USER_AGENTS[rand(@length - 1)]
      end

      def valid_agent?(agent, last_agent=nil)
        USER_AGENTS.include?(agent) and agent != nil and agent != last_agent
      end

      def send
        @time_sent = DateTime.now
        page = Nokogiri::HTML(open(@url,
                                "User-Agent" => self.user_agent
                              ))
      end
    end
  end
end
