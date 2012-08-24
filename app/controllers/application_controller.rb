class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  before_filter :authentication

  private
  def authentication
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user
    @current_user
  end
end
