class ReservesController < UserBaseController
  def new
    @feed = current_user.feeds.find(params[:feed_id])
    authentications = current_user.authentications.select { |authentication| !@feed.authentications.include?(authentication) }
    @reserves = authentications.map { |authentication| @feed.reserves.build(authentication_id: authentication.id, posts_at: Time.now) }
  end

  def create
    @feed = current_user.feeds.find(params[:feed_id])
    params[:reserves] && params[:reserves].each do |reserve|
      @feed.reserves.build(reserve.merge(reserved_at: Time.now))
    end
    if @feed.save
      redirect_to feed_path(@feed)
    else
      render action: :new
    end
  end

  def edit
    @feed = current_user.feeds.find(params[:feed_id])
    @reserve = @feed.reserves.find(params[:id])
  end

  def update
    @feed = current_user.feeds.find(params[:feed_id])
    @reserve = @feed.reserves.find(params[:id])
    if @reserve.update_attributes(params[:reserve])
      redirect_to feed_path(@feed)
    else
      render action: :edit
    end
  end

  def destroy
    reserve = current_user.feeds.find(params[:feed_id]).reserves.find(params[:id])
    reserve.destroy

    redirect_to :back
  end

end
