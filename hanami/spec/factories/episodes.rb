Factory.define :episode do |f|
  f.association(:podcast)

  f.name { fake(:hipster, :sentence) }
  f.published { fake :time, :backward, days: 30 }

  f.id { SecureRandom.uuid }
  f.timestamps

  f.trait :deleted do |x|
    x.deleted_at { fake :time, :backward, days: 3 }
  end

  f.trait :draft do |x|
    x.published { nil }
  end
end
