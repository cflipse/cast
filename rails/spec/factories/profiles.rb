FactoryBot.define do
  factory :profile do
    login { Faker::Internet.username(separators: %w[_ -]) }
    email { Faker::Internet.email }
    display_name { Faker::Name.name }

    trait :admin do
      admin { true }
    end
  end
end
