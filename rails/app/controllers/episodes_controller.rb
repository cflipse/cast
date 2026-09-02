class EpisodesController < ApplicationController
  after_action :verify_authorized

  before_action do
    @podcast = Podcast.find_by!(slug: params[:podcast_id])
  end

  def show
    @episode = find_episode

    authorize @episode
  end

  def new
    @episode = authorize @podcast.episodes.build(
      published: Date.today,
      number: (@podcast.episodes.maximum(:number) || 0).succ,
      explicit: @podcast.explicit
    )
  end

  def edit
    @episode = authorize find_episode
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
    @episode = authorize find_episode

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
    @episode = authorize find_episode

    @episode.update(deleted_at: Time.current)

    redirect_to podcast_path(@podcast),
      notice: "#{@episode.title} has been removed"
  end

  private

  # Episodes are addressed publicly (and in all generated routes, since
  # Episode#to_param returns the slug/uuid) by uuid or slug -- never the
  # internal integer id -- so every action that receives params[:id] must
  # look up the same way #show does.
  def find_episode
    @podcast.episodes.where(uuid: params[:id])
      .or(@podcast.episodes.by_slug(params[:id])).first!
  end

  def return_path
    if params[:index].present?
      podcast_path(@podcast)
    else
      podcast_episode_path(@podcast, @episode.slug)
    end
  end
end
