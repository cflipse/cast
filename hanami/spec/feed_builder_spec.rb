require "rss"

RSpec.describe Cast::FeedBuilder do

  let(:podcast) do
    double :podcast,
      name: "Bone, Stone & Obsidian", slug: "bso",
      description: "this is a test",
      updated_at: Time.now,
      created_at: Time.now - 10,
      explicit: true,
      episodes: episodes,
      image_data: { id: "image/bso.png", storage: "store" }
  end

  let(:episodes) do
    [
      double(:episode,
             name: "the first test",
             uuid: SecureRandom.uuid,
             description: "kaboom",
             published: Time.now.to_s,
             slugs: ["test one", "test-one"],
             explicit: false,
             audio_data: {
               id: "episode/1.mp3", storage: "store",
               metadata: { duration: 1523, size: 987654, mime_type: "audio/mpeg" }
             },
      )
    ]
  end

  let(:routes) { double(:routes, url: "https://example.com/bso") }
  let(:parser) { RSS::Parser }

  describe "#call" do
    it "presents the podcast" do
      feed = described_class.new.call(podcast, routes)
      bso = parser.parse(feed.to_s)

      expect(bso.channel).to have_attributes(
        title: "Bone, Stone & Obsidian",
        link: "https://example.com/bso",
        itunes_explicit: "yes",
      )
    end

    it "presents episodes" do
      feed = described_class.new.call(podcast, routes)
      bso = parser.parse(feed.to_s)

      expect(bso.items.first).to have_attributes(
        title: "the first test",
        enclosure: have_attributes(url: match(%{casts/test/episode/1.mp3}), type: "audio/mpeg"),
        itunes_explicit: "no",
        link: "https://example.com/bso",
      )
    end
  end
end
