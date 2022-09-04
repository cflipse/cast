class Episode < ApplicationRecord
  belongs_to :podcast

  validates :name, presence: true
  validates :number, numericality: true,
    uniqueness: {scope: :podcast_id},
    allow_nil: true

  include AudioUploader::Attachment(:audio)

  def title
    if number
      "Episode #{number}: #{name}"
    else
      name
    end
  end
end
