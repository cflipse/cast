# frozen_string_literal: true

RSpec.describe Cast::Actions::Home::Index do
  let(:params) { Hash[] }
  let(:podcasts) { Cast::App["repos.podcast_repo"] }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end

  it "presents all podcasts", :db do
    podcasts.create(
      name: "Bone, Stone & Obsidian",
      slug: "bso",
      explicit: false,
    )

    podcasts.create(
      name: "Fireside with Rajaat",
      slug: "chat",
      explicit: true,
    )

    response = subject.call(params)

    expect(response.body).to include(/Fireside with Rajaat/)
  end
end
