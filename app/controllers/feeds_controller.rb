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
      @feed.reserves.build(authentication_id: authentication.id) unless @feed.authentications.include?(authentication)
    end
  end

  def update
    @feed = current_user.feeds.find(params[:feed])
    reserves_ = params[:reserves].keys.map { |key| key.to_i }
    reserve_ids = @feed.reserves.map { |reserve| reserve.id } | reserves_
    reserve_ids.each do |reserve_id|
      if reserves_.include(reserve_id)
        reserve = @feed.reserves.find_or_initialize_by_id(reserve_id)
      else
        idx = @feed.reserves.index { |reserve| reserve.id == reserve_id }
        @feed.reserves[idx].destroy
      end
    end

    if @feed.save
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
end
