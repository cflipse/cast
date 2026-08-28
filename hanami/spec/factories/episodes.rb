Factory.define :episode do |f|
  f.association(:podcast)

  f.name { fake(:hipster, :sentence) }

  f.id { SecureRandom.uuid }
  f.timestamps
end

