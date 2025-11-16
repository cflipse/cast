class PodcastHost < ApplicationRecord
  belongs_to :profile
  belongs_to :podcast
end
