class Profile < ApplicationRecord
  has_many :podcast_hosts
  has_many :podcasts, through: :podcast_hosts

  validates :login, presence: true
  validates :email, presence: true, format: /.*@.+/
end
