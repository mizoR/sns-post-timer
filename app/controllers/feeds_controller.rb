class FeedsController < ApplicationController
  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
    current_user.authentications.each do |authentication|
      @feed.reserves.build(authentication_id: authentication.id)
    end
  end

  def create
    @feed = Feed.new(params[:feed])
    params[:reserves] && params[:reserves].each do |reserve|
      authentication = current_user.authentications.find(reserve['authentication_id'])
      @feed.reserves.build(reserve.merge(authentication_id: authentication.id, reserved_at: Time.now))
    end
    if @feed.save
      redirect_to feed_path(@feed)
    else
      render action: 'new'
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def destroy
    feed = Feed.find(params[:id])
    feed.destroy
    redirect_to feeds_path
  end
end
