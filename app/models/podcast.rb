class Podcast < ApplicationRecord
  has_many :episodes, -> { order :number }

  has_many :podcast_hosts
  has_many :hosts, through: :podcast_hosts, source: :profile

  validates :name, presence: true
  validates :slug, presence: true
end
