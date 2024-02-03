require "rails_helper"

RSpec.describe Episode do
  let(:podcast) { build_stubbed :podcast }

  describe "#title" do
    context "when a number is defined" do
      it "incorporates the number into the episode title" do
        episode = described_class.new name: "Testing Things", number: 70, podcast: podcast
        expect(episode).to be_valid
        expect(episode.title).to eq "Episode 70: Testing Things"
      end
    end

    context "when no number is defined" do
      it "uses the bare episode name as the title" do
        episode = described_class.new name: "Some Other Things", number: nil, podcast: podcast

        expect(episode).to be_valid
        expect(episode.title).to eq "Some Other Things"
      end
    end
  end

  specify "changes update the parent podcast" do
    podcast = create :podcast, updated_at: 5.days.ago
    create :episode, podcast: podcast

    expect(podcast.updated_at).to be_within(1.second).of(Time.zone.now)
  end

  describe "#slugs" do
    it "is generated from the episode and title" do
      episode = build :episode, number: 34, name: "Testing a Thing"
      episode.save

      expect(episode.slugs).to eq(["34-testing-a-thing"])
    end

    it "only preserves saved slugs" do
      episode = build :episode, number: 34, name: "Testing a Thing"
      episode.validate

      episode.name = "ooops, something else"
      episode.save

      expect(episode.slugs).to eq(["34-ooops-something-else"])
    end

    it "keeps the most recent slug on top" do
      episode = create :episode, number: nil, name: "Testing a Thing"
      episode.update(number: 77)
      expect(episode.slugs).to eq([
        "77-testing-a-thing",
        "testing-a-thing"
      ])
    end

    it "is findable by it's slugs" do
      episode = create :episode, number: nil, name: "Testing a Thing"
      episode.update(number: 77)

      expect(Episode.by_slug("77-testing-a-thing").first).to eq episode
      expect(Episode.by_slug("testing-a-thing").first).to eq episode
    end

    it "does not duplicate slugs" do
      episode = create :episode, number: nil, name: "Testing a Thing"
      episode.update show_notes: "A thing happened.  It was hilarious"

      expect(episode.slugs).to eq ["testing-a-thing"]
    end
  end
end
