require "rails_helper"

RSpec.describe PodcastPolicy, type: :policy do
  let(:podcast) { FactoryBot.build_stubbed :podcast }
  subject(:policy) { described_class.new user, podcast }

  context "a guest" do
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
    it { is_expected.not_to be_create }
    it { is_expected.not_to be_destroy }
  end

  context "an admin" do
    let(:user) { FactoryBot.build_stubbed :profile, :admin }

    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.to be_create }
    it { is_expected.to be_update }
    it { is_expected.to be_destroy }
  end
end
