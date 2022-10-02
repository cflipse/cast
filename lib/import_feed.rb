require "open-uri"
require "nokogiri"

class ImportFeed
  include ActionView::Helpers::SanitizeHelper

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
        description: channel.at_xpath("itunes:summary").gsub(/<br .*$/m, ""),
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
    title = item.at_xpath("title").content
    puts title

    # extract name and number from the original compound title
    if title =~ /^.*Episode (\d+): (.*)$/
      title = $2
      number = $1
    end

    podcast.episodes.build(
      name: title,
      number: number,
      description: item.at_xpath("itunes:summary").content,
      show_notes: show_notes(item),
      published: item.at_xpath("pubDate").content,
      audio_remote_url: item.at_xpath("enclosure")["url"],
      explicit: item.at_xpath("itunes:explicit")&.content == "yes"
    )
  end

  def show_notes(item)
    item.at_xpath("content:encoded").content
      .then { |html| sanitize html }
      .then { |html| kramdown html }
      .then { |kd| strip_tags kd }
  end

  def kramdown(html)
    Kramdown::Document.new(html, html_to_native: true, input: "html").to_kramdown
  end
end
