class Reserve < ActiveRecord::Base
  attr_accessible :authentication_id, :feed_id, :posts_at, :reserved_at

  belongs_to :authentication
  belongs_to :feed
end
