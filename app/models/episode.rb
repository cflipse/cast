class Episode < ApplicationRecord
  belongs_to :podcast, touch: true

  include AudioUploader::Attachment(:audio)

  normalizes :slugs, with: -> { _1.map(&:parameterize).uniq }

  before_save :slugify

  validates :name, presence: true
  validates :number, numericality: true,
    uniqueness: {scope: :podcast_id},
    allow_nil: true

  delegate :duration, to: :audio

  scope :published, -> { where(deleted_at: nil).and where.not(published: nil) }

  scope :by_slug, ->(slug) {
    where("slugs @> ?", "{#{slug}}")
  }

  def slug
    slugs.first.presence || id
  end

  def title
    if number
      "Episode #{number}: #{name}"
    else
      name
    end
  end

  private

  def slugify
    [number, name.parameterize].join("-")
      .then { |slug| slugs.unshift slug }
  end
end
