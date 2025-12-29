Factory.define(:profile) do |f|
  f.uuid { SecureRandom.uuid }
  f.email { fake(:internet, :email) }
  f.login { fake(:internet, :username) }
  f.display_name { fake(:name, :name) }

  f.created_at { Time.now.utc }
  f.updated_at { Time.now.utc }

  f.bio { fake(:lorem, :sentence) }
  f.roles { [] }

  f.trait :admin do |t|
    t.admin { true }
  end
end
