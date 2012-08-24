class SessionsController < ApplicationController

  def create
    user = User.find_by_username params[:username]
    if user.authentication?(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'login was success.'
    else
      redirect_to :back, alert: 'username or password was wrong.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
