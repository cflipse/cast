class PodcastsController < ApplicationController
  def index
    @podcasts = Podcast.all
  end

  def new
    @podcast = Podcast.new
  end

  def create
    @podcast = Podcast.new params.require(:podcast)
      .permit(:name, :description, :explicit, :image)

    @podcast.generate_slug

    if @podcast.save
      redirect_to @podcast, notice: "Successfully added #{@podcast.name}"
    else
      render :new
    end
  end

  def show
    @podcast = Podcast.find(params[:id])
  end
end
