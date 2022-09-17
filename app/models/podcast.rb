class Podcast < ApplicationRecord
  include CoverUploader::Attachment(:image)

  has_many :episodes, -> { order published: :desc },
    dependent: :destroy

  has_many :podcast_hosts, dependent: :destroy
  has_many :hosts, through: :podcast_hosts, source: :profile

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def generate_slug
    self.slug = name.parameterize
  end

  def to_param
    slug
  end
end
