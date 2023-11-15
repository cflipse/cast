require "rails_helper"

RSpec.describe Podcast do
  describe "#episodes" do
    it "orders the stored episodes by published date, reversed" do
      podcast = FactoryBot.create :podcast
      third = FactoryBot.create :episode, podcast: podcast, number: 2,
        published: 1.weeks.ago
      first = FactoryBot.create :episode, podcast: podcast, number: 1,
        published: 3.weeks.ago
      second = FactoryBot.create :episode, podcast: podcast, number: nil,
        published: 2.weeks.ago

      expect(podcast.episodes).to eq([third, second, first])
    end
  end
end
