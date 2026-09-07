# frozen_string_literal: true

RSpec.describe Cast::Views::Parts::Podcast do
  subject { described_class.new(value:) }
  let(:value) { double("podcast") }

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end
end
