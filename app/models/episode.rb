class Episode < ApplicationRecord
  belongs_to :podcast

  validates :name, presence: true
  validates :number, numericality: true, uniqueness: {scope: :podcast_id}
end
