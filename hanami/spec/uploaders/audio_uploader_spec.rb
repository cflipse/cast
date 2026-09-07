RSpec.describe Cast::Uploaders::AudioUploader, :shrine do
  let(:file) { SPEC_ROOT.join("fixtures/bso001-templars.mp3") }

  let(:uploader) { described_class.new(:store) }

  it "extracts metadata" do
    resp = uploader.upload(file.open)

    expect(resp).to have_attributes(
      mime_type: "audio/mpeg",
      extension: "mp3",
      duration: 3286, # actual length of episode,
      size: file.size,
    )
  end
end
