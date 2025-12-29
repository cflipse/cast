Factory.define(:podcast) do |f|
  f.uuid { SecureRandom.uuid }
  f.name { fake(:book, :title) }
  f.slug { |name| name.downcase.tr(" ", "-") }

  f.created_at { Time.now.utc }
  f.updated_at { Time.now.utc }

  f.image_data { {} }
  f.timestamps
end
