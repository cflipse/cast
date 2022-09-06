module ShrineData
  module_function

  def data(type)
    json = case type.to_sym
    when :cover then uploaded_cover
    when :audio then uploaded_audio
    else
      raise "Unknown data type"
    end

    Shrine::Attacher.new
      .tap { |a| a.set(json) }
      .data
  end

  def uploaded_cover
    file = File.open("spec/fixtures/bso-logo.jpg", binmode: true)

    # for performance we skip metadata extraction and assign test metadata
    Shrine.upload(file, :store, metadata: false).tap do |uf|
      uf.metadata.merge! "size" => 83642,
        "mime_type" => "image/jpeg", "filename" => "bso-logo.jpg"
    end
  end

  def uploaded_audio
    file = File.open("spec/fixtures/Audio-teaser-for-The-Streets-of-Avalon-KS.mp3")

    Shrine.upload(file, :store, metadata: false).tap do |uf|
      uf.metadata.merge!(
        "mime_type" => "audio/mpeg",
        "extension" => "mp3",
        "duration" => 118,
        "size" => 895233
      )
    end
  end
end
