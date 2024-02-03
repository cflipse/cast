class EpisodesController < ApplicationController
  after_action :verify_authorized

  before_action do
    @podcast = Podcast.find_by(slug: params[:podcast_id])
  end

  def show
    @episode = authorize @podcast.episodes.find(params[:id])
  end

  def new
    @episode = authorize @podcast.episodes.build(
      published: Date.today,
      number: (@podcast.episodes.maximum(:number) || 0).succ,
      explicit: @podcast.explicit
    )
  end

  def edit
    @episode = authorize @podcast.episodes.find(params[:id])
  end

  def create
    @episode = authorize @podcast.episodes.build params.require(:episode)
      .permit(:name, :number, :published, :audio, :description, :show_notes, :explicit)

    if @episode.save
      redirect_to podcast_path(@podcast),
        notice: "#{@episode.title} has been added"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @episode = authorize @podcast.episodes.find(params[:id])

    @episode.attributes = params.require(:episode)
      .permit(:name, :number, :published, :audio, :description, :show_notes, :explicit)

    if @episode.save
      redirect_to return_path,
        notice: "#{@episode.title} has been updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @episode = authorize @podcast.episodes.find(params[:id])

    @episode.update(deleted_at: Time.current)

    redirect_to podcast_path(@podcast),
      notice: "#{@episode.title} has been removed"
  end

  private

  def return_path
    if params[:index].present?
      podcast_path(@podcast)
    else
      podcast_episode_path(@podcast, @episode)
    end
  end
end
