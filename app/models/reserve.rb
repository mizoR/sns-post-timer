class Reserve < ActiveRecord::Base
  attr_accessible :authentication_id, :feed_id, :posts_at, :posted_at, :reserved_at, :tried_times

  belongs_to :authentication
  belongs_to :feed
end
