namespace :import do
  desc "imports Bone, Stone & Obsidian"
  task bso: :environment do
    require "import_feed"
    import = ImportFeed.new("http://misdirectedmark.com/category/podcasts/bsao/feed/")
    cast = Podcast.find_by(slug: "bso") || import.build_podcast(slug: "bso")
    import.build_episodes(cast)

    cast.save!
  rescue ActiveRecord::RecordInvalid
    puts cast.errors.full_messages
    cast.episodes.each do |ep|
      puts ep.errors.full_messages
    end
  end
end
