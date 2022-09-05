class EpisodesController < ApplicationController
  before_action do
    @podcast = Podcast.find(params[:podcast_id])
  end

  def index
    @episodes = @podcast.episodes
  end

  def new
    @episode = @podcast.episodes.build(
      published: Date.today,
      number: (@podcast.episodes.maximum(:number) || 0).succ,
      explicit: @podcast.explicit
    )
  end

  def create
    @episode = @podcast.episodes.build params.require(:episode)
      .permit(:name, :number, :season, :published, :audio, :description, :show_notes, :explicit)

    if @episode.save
      redirect_to podcast_path(@podcast),
        notice: "#{@episode.title} has been added"
    else
      render :new
    end
  end
end
