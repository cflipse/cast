xml.instruct! :xml, version: "1.0"

xml.rss version: "2.0", "xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.link routes.url(:podcast, id: podcast.slug)
    xml.title podcast.name
  end
end
