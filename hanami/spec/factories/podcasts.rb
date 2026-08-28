
Factory.define :podcast do |f|
  f.id { SecureRandom.uuid }
  f.timestamps

  f.name { fake(:book, :title) }
  f.slug { |name| name.downcase.gsub(/ /, '-') } 

  f.explicit false

  f.trait :explicit do |x|
    x.explicit true
  end
end
