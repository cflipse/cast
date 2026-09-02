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

  scenario "guests don't see pending episodes", :pending do
    episode = Factory[:episode, podcast:, published: 1.day.from_now.to_date]

    visit podcast_path(podcast)
    expect(page).not_to have_text(episode.title)

    # verify they can't see it when the day has changed in UTC.
    travel_to Time.current.in_time_zone("America/New_York").beginning_of_day + 21.hours

    visit podcast_path(podcast)
    expect(page).not_to have_text(episode.title)
  end

  scenario "view an episode by slug or uuid", :pending do
    Factory[create :episode, :published, podcast: podcast]

    episode.update(name: "ooops, got the name wrong the first time")

    aggregate_failures do
      visit podcast_episode_url(podcast, episode.id)
      expect(page).to have_text(episode.title)

      visit podcast_episode_url(podcast, episode.slugs.first)
      expect(page).to have_text(episode.title)

      visit podcast_episode_url(podcast, episode.slugs.last)
      expect(page).to have_text(episode.title)
    end
  end
end
