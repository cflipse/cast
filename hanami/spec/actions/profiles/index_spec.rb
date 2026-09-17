# frozen_string_literal: true

RSpec.describe Cast::Actions::Profiles::Index do
  let(:params) { Hash[] }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end

  it "presents all hosts" do
    profiles = 3.times.map { Factory[:profile] }
    response = subject.call(params)

    profiles.each do |profile|
      expect(response.body).to include(%r{#{profile.display_name}})
    end
  end
end
