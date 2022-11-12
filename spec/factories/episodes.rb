FactoryBot.define do
  factory :episode do
    association :podcast
    name { Faker::Movie.title }
    sequence(:number)
    audio_data { ShrineData.data(:audio) }

    trait :published do
      published { 2.days.ago }
    end
  end
end
