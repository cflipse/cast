require "rails_helper"

RSpec.describe AudioUploader do
  let(:file) { Rails.root.join("spec/fixtures/bso001-templars.mp3") }

  let(:episode) { Episode.new audio: File.open(file) }
  let(:audio) { episode.audio }

  it "extracts metadata", :aggregate_failures do
    expect(audio.mime_type).to eq "audio/mpeg"
    expect(audio.extension).to eq "mp3"
    expect(audio.duration).to eq 3286 # length of actual episode
    expect(audio.size).to eq file.size
  end
end
