Factory.define :profile do |f|
  f.uuid { SecureRandom.uuid }

  f.login { fake :internet, :username }
  f.email { fake :internet, :email }
  f.display_name { fake :name }

  f.persistence_token { SecureRandom.uuid }
  f.roles { [] }

  f.timestamps
end

Factory.define :podcast_host do |f|
  f.association(:podcast)
  f.association(:profile)

  f.timestamps
end
