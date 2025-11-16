class CoverUploader < Shrine
  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/webp]
  end

  plugin :remote_url, max_size: 10.megabytes
end
