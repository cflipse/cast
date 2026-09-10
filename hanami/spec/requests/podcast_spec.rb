RSpec.describe "podcasts/:slug", type: :request do

  it "loads the page and it's episodes", :db do
    podcast = Factory[:podcast, slug: "bso"]
    3.times { Factory[:episode, podcast: podcast] }

    get "/podcasts/bso"

    page = Capybara.string(last_response.body)
    expect(page).to have_selector(".podcast-episodes .episode", count: 3)
  end

  it "serves an RSS feed", :db do
    Factory[:podcast, slug: "bso"]

    get "/podcasts/bso.rss"
    expect(last_response.headers).to include("content-type" => "application/rss+xml; charset=utf-8")
  end

  it "respects an accepts header", :db do
    Factory[:podcast, slug: "bso"]

    get "/podcasts/bso", {}, { "HTTP_ACCEPT" => "application/rss+xml" }

    expect(last_response.headers).to include("content-type" => "application/rss+xml; charset=utf-8")
  end

end
