Hanami.app.register_provider(:shrine) do
  prepare do
    require "shrine"
    require "shrine/storage/s3"
  end

  start do
    settings = target["settings"]

    config = {
      upload_options: { acl: "public-read" },
      access_key_id: settings.spaces_access_key_id,
      secret_access_key: settings.spaces_secret_access_key,
      endpoint: settings.spaces_endpoint,
      force_path_style: settings.spaces_force_path_style,
      bucket: settings.spaces_bucket,
      region: settings.spaces_region,
    }

    prefix = Hanami.env?(:production) ? "files" : Hanami.env 

    Shrine.storages = {
      cache: Shrine::Storage::S3.new(**config, prefix: "cache"),
      store: Shrine::Storage::S3.new(**config, prefix:),
    }

    Shrine.plugin :add_metadata
    Shrine.plugin :determine_mime_type
    Shrine.plugin :pretty_location

    Shrine.plugin :cached_attachment_data
    Shrine.plugin :type_predicates
    Shrine.plugin :validation
    Shrine.plugin :validation_helpers

    Shrine.plugin :url_options, store: {public: true, host: settings.spaces_host}

    register "shrine", Shrine
  end
end
