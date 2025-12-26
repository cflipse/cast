RSpec.describe Casts::Repos::PodcastRepo, :db do 

  subject(:repo) { Hanami.app["repos.podcast_repo"] }
  let(:podcasts) { Hanami.app["relations.podcasts"] }

  it "roundtrips image_data as JSON" do
    image_data = { "url" => "http://example.com/image.png", "width" => 600, "height" => 600 }

    id = SecureRandom.uuid

    repo.create(id:, image_data:,
      name: "Test Podcast",
      slug: "test",
    )

    expect(podcasts.by_pk(id).one[:image_data]).to eq image_data
  end
end
