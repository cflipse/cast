class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new params.require(:profile)
      .permit(:display_name, :login, :email, :bio, :avatar)

    if @profile.save
      redirect_to profile_path(@profile),
        notice: "Created profile for #{@profile.display_name}"
    else
      render :new
    end
  end

  def show
    @profile = Profile.find_by(login: params[:id])
  end

  def edit
    @profile = Profile.find_by(login: params[:id])
  end

  def update
    @profile = Profile.find_by(login: params[:id])

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
