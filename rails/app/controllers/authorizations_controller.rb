class AuthorizationsController < ApplicationController
  skip_forgery_protection

  def create
    email = request.env.dig("omniauth.auth", "info", "email")
    profile = Profile.find_by(email: email)

    if profile
      session[:current_profile_id] = profile.id

      redirect_to root_path,
        notice: "Welcome #{profile.display_name}"
    else
      redirect_to root_path, alert: "Unknown user #{email}"
    end
  end

  def destroy
    session[:current_profile_id] = nil
    redirect_back_or_to root_path,
      notice: "logged out"
  end
end
