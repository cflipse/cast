# frozen_string_literal: true

RSpec.describe Cast::Views::Parts::Episode do
  subject { described_class.new(value:) }
  let(:value) { double("episode") }

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end
end
