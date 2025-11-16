require "rails_helper"

RSpec.describe ProfilePolicy, type: :policy do
  subject(:policy) { described_class.new user, profile }
  let(:profile) { FactoryBot.build_stubbed :profile }

  context "a guest" do
    let(:user) { nil }

    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.not_to be_create }
    it { is_expected.not_to be_update }
    it { is_expected.not_to be_destroy }
  end

  context "a known user" do
    let(:user) { FactoryBot.build_stubbed :profile }
    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.not_to be_create }
    it { is_expected.not_to be_update }
    it { is_expected.not_to be_destroy }

    it "may edit it's own profile" do
      policy = described_class.new user, user
      expect(policy.update?).to be true
    end
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
