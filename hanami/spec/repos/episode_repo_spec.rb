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
  end
end
