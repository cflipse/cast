class CoverUploader < Shrine
  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png image/webp]
  end
end
