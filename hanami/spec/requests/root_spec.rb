# frozen_string_literal: true

RSpec.describe "Root", :db, type: :request do
  it "displays all podcasts" do
    Factory[:podcast, uuid: "podcast-1", name: "First Podcast"]
    Factory[:podcast, uuid: "podcast-2", name: "Second Podcast"]
    Factory[:podcast, uuid: "podcast-3", name: "Last Podcast"]

    get "/"

    expect(last_response.body).to include("First Podcast")
      .and include("Second Podcast")
      .and include("Last Podcast")
  end
end
