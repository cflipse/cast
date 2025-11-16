class PodcastHeaderComponent < ApplicationComponent
  extend Dry::Initializer

  param :podcast
  option :policy

  attr_reader :podcast

  delegate :edit?, to: :policy

  class Controls < ApplicationComponent
    extend Dry::Initializer

    param :podcast

    delegate :policy, to: :helpers

    def new?
      policy(podcast.episodes.build).new?
    end

    def edit?
      policy(podcast).edit?
    end

    def render?
      new? || edit?
    end

    def btn_css(extra)
      "bg-amber-700 hover:bg-amber-800 text-gray-300 p-3 #{extra}"
    end

    def edit_link(&)
      return unless edit?
      css = btn_css(new? ? "rounded-l-md" : "rounded-md")

      link_to(edit_podcast_url(podcast), class: css, &)
    end

    def new_link(&)
      return unless new?
      css = btn_css(edit? ? "rounded-r-md" : "rounded-md")

      link_to(new_podcast_episode_path(podcast), class: css, &)
    end
  end
end
