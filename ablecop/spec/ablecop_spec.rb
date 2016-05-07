describe Ablecop do
  it "has a version number" do
    expect(Ablecop::VERSION).not_to be nil
  end

  context "outside of Rails environment" do
    # TODO: This spec is currently order dependent. It can't be run after the
    # "within Rails environment" context.
    it "doesn't require the Railtie" do
      expect { Ablecop::Railtie }.to raise_error(NameError)
    end
  end

  context "within Rails environment" do
    before do
      stub_const("Rails", Module.new)
      load "lib/ablecop.rb"
    end

    it "requires the Railtie" do
      expect(Ablecop::Railtie).to be_a(Class)
    end
  end
end
