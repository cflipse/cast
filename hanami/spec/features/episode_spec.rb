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



end
