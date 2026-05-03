require "shrine"
require "shrine/storage/s3"

Shrine.storages[:cache]

spaces_creds = Rails.application.credentials.spaces.then do |spaces|
  {
    upload_options: {acl: "public-read"},
    access_key_id: ENV.fetch("SPACES_ACCESS_KEY_ID", spaces[:access_key_id]),
    secret_access_key: ENV.fetch("SPACES_SECRET_ACCESS_KEY", spaces[:secret_access_key]),
    endpoint: ENV.fetch("SPACES_ENDPOINT", spaces[:endpoint]),
    force_path_style: ENV.fetch("SPACES_FORCE_PATH_STYLE", spaces[:force_path_style].to_s) == "true",
    bucket: ENV.fetch("SPACES_BUCKET", spaces[:bucket]),
    region: ENV.fetch("SPACES_REGION", spaces[:region])
  }
end

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **spaces_creds),
  store: Shrine::Storage::S3.new(prefix: Rails.env.production? ? "files" : Rails.env, **spaces_creds)
}

Shrine.plugin :activerecord
Shrine.plugin :add_metadata
Shrine.plugin :determine_mime_type
Shrine.plugin :pretty_location
Shrine.plugin :cached_attachment_data
Shrine.plugin :type_predicates
Shrine.plugin :validation
Shrine.plugin :validation_helpers

Shrine.plugin :url_options, store: {public: true, host: ENV["SPACES_HOST"]}
