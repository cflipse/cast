xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0", "xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.link podcast_url(@podcast)
    xml.title @podcast.name

    xml.tag! "itunes:image", href: @podcast.image_url

    xml.tag! "itunes:owner" do
      xml.tag! "itunes:email", "flip@athas.org"
      xml.tag! "itunes:name", "The Burnt World of Athas"
    end

    xml.tag! "itunes:author", "The Burnt World of Athas"

    xml.description @podcast.description
    xml.category "Games &amp; Hobbies"
    xml.tag! "itunes:category", text: "Leisure" do
      xml.tag! "itunes:category", text: "Games"
    end

    xml.language "en-us"
    xml.lastBuildDate @podcast.updated_at

    xml.tag! "itunes:new-feed-url", podcast_url(@podcast, format: :rss)
    xml.tag! "itunes:explicit", @podcast.explicit?
    xml.tag! "itunes:summary", @podcast.description

    @podcast.episodes.published.each do |episode|
      xml.item do
        xml.title episode.title
        xml.description episode.description
        xml.tag! "itunes:summary", episode.description
        xml.pubDate episode.published
        xml.link podcast_episode_url(@podcast, episode)

        xml.guid episode.id

        xml.tag! "itunes:duration", episode.duration
        xml.tag! "itunes:explicit", episode.explicit?

        xml.enclosure url: episode.audio_url, type: episode.audio.mime_type, length: episode.audio.size
      end
    end
  end
end
