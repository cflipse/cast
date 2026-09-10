# frozen_string_literal: true

RSpec.describe Cast::Actions::Feed::Show do
  let(:params) { Hash[id: "bso"] }

  it "works", :db do
    Factory[:podcast, slug: "bso"]

    response = subject.call(params)
    expect(response).to be_successful
  end
end
