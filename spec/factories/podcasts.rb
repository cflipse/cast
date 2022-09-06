FactoryBot.define do
  factory :podcast do
    name { [Faker::Hacker.ingverb, Faker::Hacker.noun].join(" ") }
    slug { name.downcase.parameterize }
    explicit { false }
    image_data { ShrineData.data(:cover) }
  end
end
