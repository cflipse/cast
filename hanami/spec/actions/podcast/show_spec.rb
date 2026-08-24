# frozen_string_literal: true

RSpec.describe Cast::Actions::Podcast::Show do
  let(:params) { Hash[id: "bso"] }
  let(:podcasts) { Cast::App["repos.podcast_repo"] }

  it "works", :db do
    podcasts.create(
      name: "Bone, Stone & Obsidian",
      slug: "bso",
      explicit: false,
    )

    response = subject.call(params)
    expect(response).to be_successful
  end
end
