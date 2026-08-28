RSpec.describe "podcasts/:slug", type: :request do

  it "loads the page and it's episodes", :db do
    podcast = Factory[:podcast, slug: "bso"]
    3.times { Factory[:episode, podcast: podcast] }

    get "/podcasts/bso"

    page = Capybara.string(last_response.body)
    expect(page).to have_selector(".podcast-episodes .episode", count: 3)
  end

end
