FactoryBot.define do
  factory :podcast do
    name { [Faker::Haker.ingverb, Faker::Hacker.noun].join(" ") }
    slug { name.downcase.slugify }
    explicit { false }
  end
end
