require "spec_helper"

describe Google::Scholar::Request do
  it "should have an user agent" do
    request = Google::Scholar::Request.new
    request.user_agent.should_not == nil
    request.user_agent.include?("Mozilla/5.0")
  end

  it "should have a different user agent by request" do
    request = Google::Scholar::Request
    r = request.new
    r1 = request.new(nil, r.user_agent)
    r.user_agent.should_not == r1.user_agent
  end
end
