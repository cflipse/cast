class Podcast < ApplicationRecord
  has_many :episodes, -> { order :number }
end
