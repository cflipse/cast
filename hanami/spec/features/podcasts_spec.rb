RSpec.feature "Podcast index", :db do
  it "shows a list of podcasts" do
    Factory[:podcast, name: "First Podcast"]
    Factory[:podcast, name: "Second Podcast"]
    Factory[:podcast, name: "Last Podcast"]

    visit "/"

    aggregate_failures "podcast list" do
      expect(page).to have_content("First Podcast")
      expect(page).to have_content("Last Podcast")
      expect(page).to have_content("Second Podcast")
    end
  end
end
