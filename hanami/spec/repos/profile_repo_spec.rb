RSpec.describe Casts::Repos::ProfileRepo, :db do
  it "roudtrips the roles as an array" do
    repo = Hanami.app["repos.profile_repo"]

    profile = repo.create(display_name: "Alice", login: "alice", roles: %w[admin user], email: "alice@example.com",
      uuid: SecureRandom.uuid)
    pp profile

    fetched = repo.find(profile[:id])
    expect(fetched.roles).to eq(%w[admin user])
  end
end
