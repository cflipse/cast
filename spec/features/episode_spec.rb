require "rails_helper"

RSpec.feature "Episodes", type: :feature do
  let(:podcast) { create :podcast }

  scenario "Create a new episode" do
    login_as FactoryBot.create :profile, roles: [podcast.slug]

    visit podcast_path(podcast)

    click_on "New Episode"

    fill_in "Name", with: "Defilers are bad, mkay?"
    fill_in "Number", with: 4
    fill_in "Published", with: "2021-10-30"

    attach_file "Audio", Rails.root.join("spec/fixtures/bso001-templars.mp3")

    expect {
      click_on "Create Episode"
    }.to change(Episode, :count).by 1

    expect(page).to have_content("Episode 4: Defilers are bad, mkay?")
  end

  scenario "Edit an episode from show" do
    login_as FactoryBot.create :profile, roles: [podcast.slug]

    episode = create :episode, :published, podcast: podcast

    visit podcast_path(podcast)
    click_on episode.title

    lorem = Faker::Lorem.paragraph(sentence_count: 5)

    click_on "Edit Episode"

    fill_in "Season", with: 2
    fill_in "Number", with: 1

    fill_in "Show notes", with: lorem

    click_on "Update Episode"

    expect(page).to have_content("Episode 1: #{episode.name}")
      .and have_content(lorem)
  end

  scenario "Delete an episode", js: true do
    login_as FactoryBot.create :profile, roles: [podcast.slug]

    episode = create :episode, :published, podcast: podcast

    visit podcast_path(podcast)
    click_on episode.title

    click_on "Delete Episode"
    accept_confirm

    expect(page).not_to have_selector("main", text: episode.name)
  end

  scenario "guests can view an episode", js: true do
    episode = create :episode, :published, podcast: podcast

    visit "/"
    click_on podcast.name
    click_on episode.title

    expect(page).to have_selector("audio[src='#{episode.audio_url}']")
  end
end
