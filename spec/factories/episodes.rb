FactoryBot.define do
  factory :episode do
    association :podcast
    name { Faker::Movie.title }
    sequence(:number)
    audio { File.open Rails.root.join("spec/fixtures/bso001-templars.mp3") }
  end
end
