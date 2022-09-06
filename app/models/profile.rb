class Profile < ApplicationRecord
  has_many :podcast_hosts
  has_many :podcasts, through: :podcast_hosts

  validates :login, presence: true
  validates :email, presence: true, format: /.*@.+/

  validates :display_name, presence: true

  def avatar_url
    avatar.presence || gravatar_url
  end

  def to_param
    login
  end

  private

  def gravatar_url
    digest = Digest::MD5.hexdigest(email.strip.downcase)

    "https://gravatar.com/avatar/#{digest}"
  end
end
