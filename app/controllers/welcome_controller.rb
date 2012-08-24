class WelcomeController < ApplicationController
  before_filter :block_user

  def index
    @user = User.new
  end

  private
  def block_user
    if current_user
      redirect_to(dashboard_path)
      return false 
    end
  end
end
