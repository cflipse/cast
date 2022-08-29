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
end
