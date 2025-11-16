class Episode < ApplicationRecord
  belongs_to :podcast, touch: true

  include AudioUploader::Attachment(:audio)

  normalizes :slugs, with: -> { it.map(&:parameterize).uniq }

  before_save :slugify

  validates :name, presence: true
  validates :number, numericality: true,
    uniqueness: {scope: :podcast_id},
    allow_nil: true

  delegate :duration, to: :audio

  scope :undeleted, -> { where(deleted_at: nil) }
  scope :published, -> { undeleted.where.not(published: nil) }
  scope :live, -> {
    published.where "published <= ?",
      Time.now.in_time_zone("America/New_York").change(hour: 8, min: 0)
  }

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
