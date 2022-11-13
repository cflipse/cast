class PodcastHeaderComponent < ApplicationComponent
  extend Dry::Initializer

  param :podcast
  option :policy

  attr_reader :podcast

  delegate :edit?, to: :policy
end
