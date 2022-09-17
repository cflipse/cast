require "open-uri"
require "nokogiri"

class ImportFeed
  def initialize(feed)
    @url = feed
  end

  def feed
    @feed ||= Nokogiri::XML URI.open(@url)
  end

  def channel
    @channel ||= feed.at_xpath("//channel")
  end

  def build_podcast(**opts)
    Podcast.new(
      opts.reverse_merge(
        name: channel.at_xpath("title").content,
        description: channel.at_xpath("itunes:summary").content,
        updated_at: channel.at_xpath("lastBuildDate").content,
        image_remote_url: channel.at_xpath("itunes:image")["href"],
        explicit: channel.at_xpath("itunes:explicit").content == "yes"
      )
    )
  end

  def build_episodes(podcast)
    feed.xpath("//item").each do |item|
      build_episode(podcast, item)
    end
  end

  def build_episode(podcast, item)
    podcast.episodes.build(
      name: item.at_xpath("title").content,
      description: item.at_xpath("itunes:summary").content,
      show_notes: kramdown(item.at_xpath("content:encoded").content),
      published: item.at_xpath("pubDate").content,
      audio_remote_url: item.at_xpath("enclosure")["url"],
      explicit: item.at_xpath("itunes:explicit")&.content == "yes"
    )
  end

  def kramdown(html)
    Kramdown::Document.new(html, html_to_native: true).to_kramdown
  end
end
