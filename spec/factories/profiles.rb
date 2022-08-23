FactoryBot.define do
  factory :profile do
    login { Faker::Internet.username }
    email { Faker::Internet.email }
    display_name { Faker::Name.name }
  end
end
