class ProfilesController < ApplicationController
  after_action :verify_authorized

  def index
    @profiles = authorize Profile.all
  end

  def new
    @profile = authorize Profile.new
  end

  def create
    @profile = authorize Profile.new params.require(:profile)
      .permit(:display_name, :login, :email, :bio, :avatar)

    if @profile.save
      redirect_to profile_path(@profile),
        notice: "Created profile for #{@profile.display_name}"
    else
      render :new
    end
  end

  def show
    @profile = authorize Profile.find_by(login: params[:id])
  end

  def edit
    @profile = authorize Profile.find_by(login: params[:id])
  end

  def update
    @profile = authorize Profile.find_by(login: params[:id])

    @profile.attributes = params.require(:profile)
      .permit(:display_name, :login, :email, :bio, :avatar)

    if @profile.save
      redirect_to profile_path(@profile),
        notice: "Updated #{@profile.display_name}"
    else
      render :edit
    end
  end
end
