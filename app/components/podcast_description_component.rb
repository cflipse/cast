# frozen_string_literal: true

class PodcastDescriptionComponent < ApplicationComponent
  with_collection_parameter :podcast

  attr_reader :podcast
  attr_reader :latest

  def initialize(podcast:)
    @podcast = podcast
    @latest = podcast.episodes.first
  end

  def policy
    helpers.policy(@podcast)
  end
end
