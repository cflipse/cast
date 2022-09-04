xml.instruct! :xml, version: "1.0", "xmlsns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd"

xml.rss version: "2.0" do
  xml.channel do
    xml.link podcast_url(@podcast)
    xml.title @podcast.name

    # TODO need to add a cover image for each podcast
    # xml.tag! "itunes.image", href: @podcast.cover

    xml.tag! "itunes:owner" do
      xml.tag! "itunes:email", "flip@athas.org"
    end

    xml.description @podcast.description
    xml.category "Games &amp; Hobbies"
    xml.language "en-us"

    xml.tag! "itunes:new-feed-url", podcast_episodes_url(@podcast, format: :rss)

    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.description episode.description
        xml.pubDate episode.published

        xml.guid episode.id

        xml.tag! "itunes:duration", episode.duration

        xml.enclosure url: episode.audio_url, type: episode.audio.mime_type, length: episode.audio.size
      end
    end
  end
end
