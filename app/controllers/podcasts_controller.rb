class PodcastsController < ApplicationController
  after_action :verify_authorized, except: [:index, :show]

  def index
    @podcasts = Podcast.all
  end

  def new
    @podcast = authorize Podcast.new
  end

  def create
    @podcast = authorize Podcast.new params.require(:podcast)
      .permit(:name, :description, :explicit, :image, :slug, host_ids: [])

    @podcast.generate_slug

    if @podcast.save
      redirect_to @podcast, notice: "Successfully added #{@podcast.name}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @podcast = Podcast.find_by!(slug: params[:id])

    @episodes = if current_profile
      @podcast.episodes.undeleted
    else
      @podcast.episodes.live
    end
  end

  def edit
    @podcast = authorize Podcast.find_by!(slug: params[:id])
  end

  def update
    @podcast = authorize Podcast.find_by!(slug: params[:id])

    @podcast.attributes = params.require(:podcast)
      .permit(:name, :description, :explicit, :image, :slug, host_ids: [])

    if @podcast.save
      redirect_to @podcast, notice: "Updated #{@podcast.name}"
    else
      render :edit, status: :unprocessable_entity
    end
  end
end
