require "rails_helper"

RSpec.describe EpisodePolicy, type: :policy do
  let(:podcast) { FactoryBot.build_stubbed :podcast }
  let(:episode) { FactoryBot.build_stubbed :episode, podcast: podcast }

  subject(:policy) { described_class.new user, episode }

  context "a guest user" do
    let(:user) { nil }

    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.not_to be_create }
    it { is_expected.not_to be_update }
    it { is_expected.not_to be_destroy }
  end

  context "a known profile" do
    let(:user) { FactoryBot.build_stubbed :profile }
    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.not_to be_create }
    it { is_expected.not_to be_update }
    it { is_expected.not_to be_destroy }
  end

  context "a profile with the podcast role" do
    let(:user) { FactoryBot.build_stubbed :profile, roles: [podcast.slug] }
    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.to be_update }
    it { is_expected.to be_create }
    it { is_expected.to be_destroy }

    it "can build if only the podcast is known" do
      expect(described_class.new(user, podcast)).to be_create
    end
  end

  context "an admin" do
    let(:user) { FactoryBot.build_stubbed :profile, :admin }

    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.to be_create }
    it { is_expected.to be_update }
    it { is_expected.to be_destroy }

    it "can build if only the podcast is known" do
      expect(described_class.new(user, podcast)).to be_create
    end
  end
end
