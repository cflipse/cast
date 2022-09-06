class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new params.require(:profile)
      .permit(:display_name, :login, :email, :bio, :avatar)

    if @profile.save
      redirect_to root_path,
        notice: "Created profile for #{@profile.display_name}"
    else
      render :new
    end
  end
end
