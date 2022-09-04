require "rails_helper"

RSpec.describe AudioUploader do
  let(:file) { File.open("spec/fixtures/bso001-templars.mp3") }

  let(:episode) { Episode.new audio: file }
  let(:audio) { episode.audio }

  it "extracts metadata", :aggregate_failures do
    expect(audio.mime_type).to eq "audio/mpeg"
    expect(audio.extension).to eq "mp3"
  end
end
