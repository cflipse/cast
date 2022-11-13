class PodcastsController < ApplicationController
  after_action :verify_authorized

  def index
    @podcasts = authorize Podcast.all
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
      render :new
    end
  end

  def show
    @podcast = authorize Podcast.find_by(slug: params[:id])
  end
end
