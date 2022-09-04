require "shrine"
require "shrine/storage/s3"

Shrine.storages[:cache]

spaces_creds = Rails.application.credentials.spaces

Shrine.storages[:system] = Shrine::Storage::S3.new(
  prefix: Rails.env.production? ? "files" : Rails.env,
  upload_options: {acl: "public-read"},
  access_key_id: ENV.fetch("SPACES_ACCESS_KEY_ID", spaces_creds[:access_key_id]),
  secret_access_key: ENV.fetch("SPACES_SECRET_ACCESS_KEY", spaces_creds[:secret_access_key]),
  endpoint: ENV.fetch("SPACES_ENDPOINT", spaces_creds[:endpoint]),
  force_path_style: spaces_creds[:force_path_style],
  bucket: spaces_creds[:bucket],
  region: spaces_creds[:region]
)
