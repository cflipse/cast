Factory.define :podcast do |f|
  f.timestamps

  f.name { fake(:book, :title) }
  f.slug { |name| Hanami.app["slugger"].call(name)  } 

  f.explicit false

  f.trait :explicit do |x|
    x.explicit true
  end
end
