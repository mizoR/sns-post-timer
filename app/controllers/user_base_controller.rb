class UserBaseController < ApplicationController
  before_filter :block_non_user

  private
  def block_non_user
    if !current_user
      redirect_to root_path
      return false
    end
  end
end
