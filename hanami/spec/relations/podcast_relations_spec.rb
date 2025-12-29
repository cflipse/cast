RSpec.describe Casts::Relations::Podcasts, :db do
  subject(:podcasts) { Hanami.app["relations.podcasts"] }

  it "roundtrips image_data as JSON" do
    image_data = { "url" => "http://example.com/image.png", "width" => 600, "height" => 600 }

    uuid = SecureRandom.uuid

    podcasts.command(:create)
      .call Factory.build(:podcast, uuid:, image_data:).to_h

    expect(podcasts.by_uuid(uuid).one[:image_data]).to eq image_data
  end
end
