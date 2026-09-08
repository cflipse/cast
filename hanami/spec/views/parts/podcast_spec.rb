# frozen_string_literal: true

RSpec.describe Cast::Views::Parts::Podcast do
  subject { described_class.new(value:, markdown:) }
  let(:value) { double("podcast") }
  let(:markdown) { instance_double(Cast::Markdown, to_html: "") }

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end

  describe "#description" do
    it "sanititzes the description" do
      allow(value).to receive(:description).and_return "foo"
      subject.description

      expect(markdown).to have_received(:to_html).with("foo")
    end
  end

  describe "#episode_description" do
    it "sanitizes input" do
      allow(value).to receive_message_chain(:latest_episode, :description).and_return "episode description"

      subject.episode_description

      expect(markdown).to have_received(:to_html).with("episode description")
    end
  end
end
