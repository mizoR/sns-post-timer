class UsersController < ApplicationController

  def create
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'user was created.'
    else
      redirect_to :back, alert: 'username or password was wrong.'
    end
  end
end
