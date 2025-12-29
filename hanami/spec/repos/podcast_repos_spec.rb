RSpec.describe Casts::Repos::PodcastRepo, :db do
  subject(:repo) { Hanami.app["repos.podcast_repo"] }
  let(:podcasts) { Hanami.app["relations.podcasts"] }

  it "roundtrips image_data as JSON" do
    image_data = { "url" => "http://example.com/image.png", "width" => 600, "height" => 600 }
    uuid = SecureRandom.uuid

    repo.create(Factory.build(:podcast, uuid:, image_data:).to_h)

    expect(repo.by_uuid(uuid)[:image_data]).to eq image_data
  end
end
