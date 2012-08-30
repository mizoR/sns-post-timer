class FeedsController < UserBaseController

  def index
  end

  def show
    @feed = current_user.feeds.find(params[:id])
  end

  def new
    @feed = Feed.new
    current_user.authentications.each do |authentication|
      @feed.reserves.build(authentication_id: authentication.id, posts_at: Time.now + 1.hour)
    end
  end

  def create
    @feed = current_user.feeds.new(params[:feed])
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
    @feed = current_user.feeds.find(params[:id])
    current_user.authentications.each do |authentication|
      if !@feed.authentications.include?(authentication)
        @feed.reserves.build(authentication_id: authentication.id)
      end
    end
  end

  def update
    @feed = current_user.feeds.find(params[:id])

    if @feed.update_attributes(params[:feed])
      redirect_to feed_path(@feed)
    else
      render action: 'edit'
    end
  end

  def destroy
    feed = current_user.feeds.find(params[:id])
    feed.destroy
    redirect_to feeds_path
  end

  def bookmarklet
    if !request || !request.referer.present?
      redirect_to new_feeds_path
    end

    @feed = Feed.from_url(request.referer)
    current_user.authentications.each do |authentication|
      @feed.reserves.build(authentication_id: authentication.id, posts_at: Time.now + 1.hour)
    end
    render action: :new
  end
end
