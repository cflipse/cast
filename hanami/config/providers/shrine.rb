Hanami.app.register_provider(:shrine) do
  prepare do
    require "shrine"
    require "shrine/storage/s3"
  end

  start do
    s3_options = {
      upload_options: { acl: "public-read" },
      bucket: target["settings"].s3_bucket,
      region: target["settings"].s3_region,
      access_key_id: target["settings"].s3_access_key_id,
      secret_access_key: target["settings"].s3_secret_access_key,
      force_path_style: true,
      endpoint: target["settings"].s3_endpoint,
    }

    Shrine.storages = {
      store: Shrine::Storage::S3.new(prefix: Hanami.env == :production ? "files" : Hanami.env, **s3_options),
      cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
    }

    Shrine.plugin :entity

    Shrine.plugin :add_metadata
    Shrine.plugin :determine_mime_type

    Shrine.plugin :rack_file

    Shrine.plugin :pretty_location
    Shrine.plugin :cached_attachment_data
    Shrine.plugin :restore_cached_data

    Shrine.plugin :validation_helpers
    Shrine.plugin :type_predicates

    Shrine.plugin :url_options, store: { public: true, host: target["settings"].spaces_host }

    register :shrine, Shrine
  end
end
