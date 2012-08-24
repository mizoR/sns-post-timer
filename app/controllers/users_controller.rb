class UsersController < ApplicationController

  def create
    user = User.new(params[:user])
    if user.save
      redirect_to :back, notice: 'user was created.'
    else
      redirect_to :back, alert: 'username or password was wrong.'
    end
  end
end
