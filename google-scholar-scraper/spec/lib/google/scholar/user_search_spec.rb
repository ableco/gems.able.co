require "spec_helper"

describe Google::Scholar::UserSearch do
  it "should parse articles correctly" do
    articles = []
    page = Nokogiri::HTML(File.read(File.join(FIXTURE_DIR,"user_search.html")))
    search = Google::Scholar::UserSearch.new('dummyUser123')
    search.parse(page, articles)

    articles.count.should == 20
    # The page that get with wget for fixture has only 20 results, but thinks
    # that using an user_agent could be get 100

    article = articles.first
    article.title.should == "The adaptive decision maker"
    article.year.should == "1993"
    article.link.should == "/citations?view_op=view_citation&hl=en&oe=ASCII&user=ho9niaIAAAAJ&citation_for_view=ho9niaIAAAAJ:blknAaTinKkC"
  end

  it "should have 'citations' insisde path" do
    search = Google::Scholar::UserSearch.new('dummyUser123')
    search.path.include?('citations')
  end
end
