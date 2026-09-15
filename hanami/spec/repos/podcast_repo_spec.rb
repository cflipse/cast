RSpec.describe Cast::Repos::PodcastRepo, :db do
  subject(:repo) { described_class.new }

  describe "#index" do
    it "lists all podcasts" do
      3.times { Factory[:podcast] }

      expect(repo.index.count).to eq(3)
    end

    it "exposes the latest episode" do
      podcast = Factory[:podcast]
      Factory[:episode, podcast:, published: Date.today, name: "test episode"]
      Factory[:episode, podcast:, published: Date.today - 3]

      expect(repo.index.first.latest_episode.name).to eq "test episode"
    end

    it "exposes the hosts" do
      hosts = 2.times.map { Factory[:profile] }
      podcast = Factory[:podcast]
      hosts.map { |profile| Factory[:podcast_host, podcast:, profile:] }

      expect(repo.index.first.hosts.map(&:login)).to eq hosts.map(&:login)
    end
  end

  describe "by_slug" do
    it "includes published episodes" do
      podcast = Factory[:podcast]
      Factory[:episode, podcast:, published: Date.today, name: "test episode"]
      Factory[:episode, podcast:, published: Date.today - 3]
      3.times { Factory[:episode, :draft, podcast:] }

      expect(repo.by_slug(podcast.slug).episodes.count).to eq 2
    end
  end
end
