RSpec.describe Cast::Repos::EpisodeRepo, :db do

  subject(:repo) { described_class.new }

  describe "#published" do
    it "retreives episodes for a given podcast" do
      podcast = Factory[:podcast]
      Factory[:episode] # deliberately not the same podcast

      expect(repo.published(podcast_id: podcast.id).to_a).to be_empty
    end

    it "excludes deleted episodes" do
      deleted = Factory[:episode, deleted_at: Time.now - 30]

      expect(repo.published(podcast_id: deleted.podcast_id)).to be_empty
    end

    it "excludes episodes not yet released", :stub do
      today = Time.utc(2026, 9, 2, 0, 0, 0)
      cutoff = Time.utc(2026, 9, 1, 12, 0, 0)

      episode = Factory[:episode, published: today]
      Cast::App.container.stub("clock", instance_double("Casts::Clock", today:, cutoff:))

      expect(repo.published(podcast_id: episode.podcast_id)).to be_empty
    end
  end

  describe "#find" do
    it "loads an episode by uuid" do
      uuid = SecureRandom.uuid
      episode = Factory[:episode, uuid:]
      Factory[:episode]

      expect(repo.find(uuid).name).to eq episode.name
    end

    it "loads an episode by slug" do
      episode = Factory[:episode, slugs: ["test-one"]]
      expect(repo.find("test-one").name).to eq episode.name
    end

    it "loads an episode by an old slug" do
      episode = Factory[:episode, slugs: ["test-one", "lost-to-time"]]
      expect(repo.find("lost-to-time").name).to eq episode.name
    end
  end

  describe "create" do
    let(:podcast) { Factory[:podcast] }

    it "converts the name to a slug" do
      episode = repo.create(name: "This is a test (one)", explicit: false, podcast_id: podcast.id)

      expect(episode.slugs).to include("this-is-a-test-one")
    end

    it "respsects provided slugs" do
      episode = repo.create(name: "testing", slugs: ["random"], explicit: false, podcast_id: podcast.id)

      expect(episode.slugs).to eq(["testing", "random"])
    end

    it "populates a UUID" do
      episode = repo.create(name: "This is a test (one)", explicit: false, podcast_id: podcast.id)
      expect(episode.uuid).not_to be_empty
    end
  end

  describe "update" do
    it "adds the name to the slug list" do
      episode = Factory[:episode, slugs: ["original-flavor"]]
      updated = repo.update(episode.id, name: "Testing")

      slugs = ["testing", *episode.slugs]
      
      expect(updated.slugs).to eq(slugs)
    end

    it "presents each slug only once" do
      episode = Factory[:episode, slugs: ["original-flavor"]]
      updated = repo.update(episode.id, name: "(Original) Flavor")

      expect(updated.slugs).to eq(["original-flavor"])
    end

    it "accepts a slug override" do
      episode = Factory[:episode, slugs: ["original-flavor"]]
      updated = repo.update(episode.id, name: "Testing", slugs: ["old-slug"])

      expect(updated.slugs).to eq(["testing", "old-slug"])
    end

    it "Preserves the name slug when overriding" do
      episode = Factory[:episode, slugs: ["original-flavor"], name: "Original Flavor"]
      updated = repo.update(episode.id, slugs: ["old-slug"])

      expect(updated.slugs).to eq(["original-flavor", "old-slug"])
    end

    it "preserves the existing uuid" do
      episode = Factory[:episode]

      updated = repo.update(episode.id, name: "Testing")
      expect(updated.uuid).to eq episode.uuid
    end
  end
end
