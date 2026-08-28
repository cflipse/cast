# frozen_string_literal: true

RSpec.describe Cast::Actions::Episode::Show do
  let(:params) { Hash[podcast_id: episode.podcast.slug, id: episode[:id] ] }
  let(:episode) { Factory[:episode] }

  it "works", :db do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
