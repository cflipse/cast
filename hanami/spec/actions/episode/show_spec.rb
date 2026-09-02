# frozen_string_literal: true

RSpec.describe Cast::Actions::Episode::Show do
  let(:params) { Hash[podcast_id: episode.podcast.slug, id: episode[:uuid] ] }

  let(:episode) { Factory[:episode] }

  it "works", :db do
    response = subject.call(params)
    expect(response).to be_successful
  end

  it "404s a missing podcast", :db do
    podcast = Factory[:podcast]
    response = subject.call(podcast_id: podcast.slug, id: SecureRandom.uuid)

    expect(response).to be_not_found
  end
end
