class Episode < ApplicationRecord
  belongs_to :podcast, touch: true

  include AudioUploader::Attachment(:audio)

  validates :name, presence: true
  validates :number, numericality: true,
    uniqueness: {scope: :podcast_id},
    allow_nil: true

  delegate :duration, to: :audio

  scope :published, -> { where(deleted_at: nil).and where.not(published: nil) }

  def title
    if number
      "Episode #{number}: #{name}"
    else
      name
    end
  end
end
