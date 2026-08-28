# frozen_string_literal: true

RSpec.describe Cast::Actions::Podcast::Show do
  it "works", :db do
    Factory[:podcast, slug: "bso"]

    response = subject.call({id: "bso"})
    expect(response).to be_successful
  end
end
