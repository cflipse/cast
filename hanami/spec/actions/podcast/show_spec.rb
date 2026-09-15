# frozen_string_literal: true

RSpec.describe Cast::Actions::Podcast::Show do
  it "works", :db do
    Factory[:podcast, slug: "bso"]

    response = subject.call({id: "bso"})
    expect(response).to be_successful
  end

  it "renders rss when requested", :db do
    Factory[:podcast, slug: "bso"]

    response = subject.call({id: "bso", format: "rss"})
    expect(response).to be_successful
  end

  it "rejects non-rss or html formats" do
    response = subject.call({id: "bso", format: "json"})
    expect(response).to be_not_acceptable
  end
end
