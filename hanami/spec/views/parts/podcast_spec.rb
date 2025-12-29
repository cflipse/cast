# frozen_string_literal: true

RSpec.describe Casts::Views::Parts::Podcast do
  subject { described_class.new(value:) }
  let(:value) { double("podcast") }

  describe "#description" do
    it "coverts markdown to HTML" do
      allow(value).to receive(:description).and_return("**Bold Text**")

      expect(subject.description).to eq("<p><strong>Bold Text</strong></p>\n")
    end

    it "escapes naughty HTML" do
      allow(value).to receive(:description).and_return("<script>alert('xss')</script>")

      expect(subject.description).to eq("<p>&lt;script&gt;alert('xss')&lt;/script&gt;</p>\n")
    end
  end
end
