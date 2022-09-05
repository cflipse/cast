class Podcast < ApplicationRecord
  include CoverUploader::Attachment(:image)

  has_many :episodes, -> { order :number }

  has_many :podcast_hosts
  has_many :hosts, through: :podcast_hosts, source: :profile

  validates :name, presence: true
  validates :slug, presence: true

  def generate_slug
    self.slug = name.parameterize
  end

  def to_param
    slug
  end
end
