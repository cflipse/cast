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
        rss.channel.itunes_summary = podcast.description

        rss.channel.itunes_categories.new_category.text = "Leisure"
        rss.channel.itunes_categories.new_category.text = "Games"

        rss.channel.language = "en-us"
        rss.channel.pubDate = podcast.created_at
        rss.channel.lastBuildDate = podcast.updated_at

        rss.channel.itunes_explicit = podcast.explicit

        rss.channel.itunes_new_feed_url = routes.url(:podcast, id: podcast.slug)


        podcast.episodes.each do |episode|
          rss.items.new_item do |item|
            item.guid.content = episode.uuid
            item.title = episode.name  # todo should be title
            item.description = episode.description
            item.itunes_summary = episode.description
            item.pubDate = episode.published
            item.itunes_duration = episode.audio.duration.to_s
            item.itunes_explicit = episode.explicit

            item.enclosure.url = episode.audio_url
            item.enclosure.type = episode.audio.mime_type
            item.enclosure.length = episode.audio.size

            item.link = routes.url(:episode, podcast_id: podcast.slug, id: episode.slugs.first)
          end
        end
      end
    end
  end
end
