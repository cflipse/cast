class EpisodesController < ApplicationController
  before_action do
    @podcast = Podcast.find_by(slug: params[:podcast_id])
  end

  def show
    @episode = @podcast.episodes.find(params[:id])
  end

  def new
    @episode = @podcast.episodes.build(
      published: Date.today,
      number: (@podcast.episodes.maximum(:number) || 0).succ,
      explicit: @podcast.explicit
    )
  end

  def edit
    @episode = @podcast.episodes.find(params[:id])
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

  def update
    @episode = @podcast.episodes.find(params[:id])

    @episode.attributes = params.require(:episode)
      .permit(:name, :number, :season, :published, :audio, :description, :show_notes, :explicit)

    if @episode.save
      redirect_to podcast_episode_path(@podcast, @episode),
        notice: "#{@episode.title} has been updated"
    else
      render :edit
    end
  end
end
