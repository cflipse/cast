require "rails_helper"

RSpec.describe Profile do
  describe "#avatar_url" do
    it "uses the provided avatar value" do
      profile = described_class.new avatar: "https://google.com/avatar/foobar"

      expect(profile.avatar_url).to eq "https://google.com/avatar/foobar"
    end
  end
end
