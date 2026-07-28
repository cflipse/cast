# frozen_string_literal: true

RSpec.describe Cast::Actions::Home::Index do
  let(:params) { Hash[] }
  let(:podcasts) { Cast::App["relations.podcasts"] }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end

  it "presents all podcasts" do
    podcasts.insert(
      id: SecureRandom.uuid,
      name: "Bone, Stone & Obsidian",
      slug: "bso",
      explicit: false,
      created_at: Time.now,
      updated_at: Time.now,
    )

    podcasts.insert(
      id: SecureRandom.uuid,
      name: "Fireside with Rajaat",
      slug: "chat",
      explicit: true,
      created_at: Time.now,
      updated_at: Time.now,
    )

    response = subject.call(params)

    expect(response.body).to include(/Fireside with Rajaat/)
  end
end
