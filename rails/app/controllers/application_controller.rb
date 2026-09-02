class ApplicationController < ActionController::Base
  include Pundit::Authorization

  def current_profile
    @current_profile ||= Profile.find_by(uuid: session[:current_profile_id])
  end

  helper_method :current_profile

  def pundit_user
    current_profile
  end
end
