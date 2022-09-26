class ApplicationController < ActionController::Base
  def current_profile
    @current_profile ||= Profile.find_by(id: session[:current_profile_id])
  end

  helper_method :current_profile
end
