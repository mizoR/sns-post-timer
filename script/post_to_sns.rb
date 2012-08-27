#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

reserves = Reserve.where('posted_at IS NULL AND posts_at <= ?', Time.now)

reserves.each do |reserve|
  feed = reserve.feed
  authentication = reserve.authentication
  case authentication.service_type
  when 'facebook'
    params = {
      message:     feed.message,
      picture:     feed.picture,
      link:        feed.link,
      name:        feed.name,
      description: feed.description }
    if authentication.facebook.feed!(params)
      reserve.update_attributes(posted_at: Time.now, tried_times: reserve.tried_times + 1)
    end
  when 'twitter'
  end
end

