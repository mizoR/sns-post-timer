class FeedsController < UserBaseController

  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
    current_user.authentications.each do |authentication|
      @feed.reserves.build(authentication_id: authentication.id, posts_at: Time.now + 1.hour)
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
      render action: 'new'
    end
  end

  def destroy
    feed = Feed.find(params[:id])
    feed.destroy
    redirect_to feeds_path
  end

  def bookmarklet
    @feed = if request && request.referer.present?
              Feed.from_url(request.referer)
            else
              Feed.new(params[:feed])
            end
    current_user.authentications.each do |authentication|
      @feed.reserves.build(authentication_id: authentication.id, posts_at: Time.now + 1.hour)
    end
    render action: :new
  end
end
