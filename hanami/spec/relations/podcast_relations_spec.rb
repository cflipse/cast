RSpec.describe Casts::Relations::Podcasts, :db do 

  subject(:podcasts) { Hanami.app["relations.podcasts"] }

  it "roundtrips image_data as JSON" do
    image_data = { "url" => "http://example.com/image.png", "width" => 600, "height" => 600 }

    id = SecureRandom.uuid

    podcasts.insert(
      id:,
      image_data:,
      name: "Test Podcast",
      slug: "test",
      created_at: Time.now,
      updated_at: Time.now,
    )

    expect(podcasts.by_pk(id).one[:image_data]).to eq image_data
  end


end
