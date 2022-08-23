FactoryBot.define do
  factory :episode do
    association :podcast
    name { Faker::Movie.title }
    sequence(:number)
  end
end
