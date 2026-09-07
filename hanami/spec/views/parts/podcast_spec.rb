# frozen_string_literal: true

RSpec.describe Cast::Views::Parts::Podcast do
  subject { described_class.new(value:) }
  let(:value) { double("podcast") }

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end

  describe "#description" do
    it "sanitizes input" do
      allow(value).to receive(:description).and_return "<script>alert()</script>"
      expect(subject.description).not_to include("<script>")
    end

    it "converts input to markdown" do
      allow(value).to receive(:description).and_return <<~MD
        * this is a test
        * of two list items
      MD

      expect(subject.description).to include("<li>this is a test</li>")
    end
  end

  describe "#episode_description" do
    it "sanitizes input" do
      allow(value).to receive_message_chain(:latest_episode, :description).and_return "<script>alert()</script>"
      expect(subject.episode_description).not_to include("<script>")
    end

    it "converts input to markdown" do
      allow(value).to receive_message_chain(:latest_episode, :description).and_return <<~MD
        * this is a test
        * of two list items
      MD

      expect(subject.episode_description).to include("<li>this is a test</li>")
    end
  end
end
