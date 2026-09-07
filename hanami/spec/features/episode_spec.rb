RSpec.feature "guests viewing an episode" do

  scenario "guests can view an episode", :db do
    podcast = Factory[:podcast]
    episode = Factory[:episode, podcast:]

    visit "/"
    click_on podcast.name

    # click_on episode.title # todo: implement title!
    click_on episode.name

    expect(page).to have_selector("h1", text: episode.name)

    #expect(page).to have_selector("audio[src='#{episode.audio_url}']")
  end

  scenario "guests don't see pending episodes" do
    tomorrow = Date.today + 1

    podcast = Factory[:podcast]
    episode = Factory[:episode, podcast:, published: tomorrow]

    visit "/podcasts/#{podcast.slug}/episodes/#{episode.uuid}"
    expect(page).not_to have_text(episode.name)
  end

  scenario "view an episode by slug or uuid" do
    podcast = Factory[:podcast]
    episode = Factory[:episode, :published, podcast:, slugs: ["slug-the-first", "slug-the-last"]]

    aggregate_failures do
      visit "/podcasts/#{podcast.slug}/episodes/#{episode.uuid}"
      expect(page).to have_text(episode.name)

      visit "/podcasts/#{podcast.slug}/episodes/#{episode.slugs.first}"
      expect(page).to have_text(episode.name)

      visit "/podcasts/#{podcast.slug}/episodes/#{episode.slugs.last}"
      expect(page).to have_text(episode.name)
    end
  end
end
