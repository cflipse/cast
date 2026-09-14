require "rss"

module Cast
  class FeedBuilder
    def call(podcast, routes)
      podcast = Cast::Views::Parts::Podcast.new(value: podcast)
      RSS::Maker.make("2.0") do  |rss|
        rss.channel.title = podcast.name
        rss.channel.link = routes.url(:podcast, id: podcast.slug)

        rss.channel.itunes_image = podcast.image_url
        rss.channel.itunes_owner.itunes_email = "flip@athas.org"
        rss.channel.itunes_owner.itunes_name = "The Burnt World of Athas"

        rss.channel.itunes_author = "The Burnt World of Athas"

        rss.channel.description = podcast.description

        rss.channel.itunes_categories.new_category.text = "Leisure"
        rss.channel.itunes_categories.new_category.text = "Games"

      end
    end
  end
end
