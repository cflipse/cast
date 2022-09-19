class PodcastHeaderComponent < ApplicationComponent
  def initialize podcast:
    @podcast = podcast
  end

  attr_reader :podcast
end
