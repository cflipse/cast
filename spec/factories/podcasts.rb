FactoryBot.define do
  factory :podcast do
    name { [Faker::Hacker.ingverb, Faker::Hacker.noun].join(" ") }
    slug { name.downcase.parameterize }
    explicit { false }
  end
end
