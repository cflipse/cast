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
end
