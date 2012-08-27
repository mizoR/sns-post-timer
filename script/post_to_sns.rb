#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'open-uri'

MAX_TRIED_TIMES = 3

reserves = Reserve.where('posted_at IS NULL AND posts_at <= ? AND tried_times < ?', Time.now, MAX_TRIED_TIMES)

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
    twitter = Settings.web_services.twitter
    Twitter.configure do |config|
      config.consumer_key       = twitter.access_token
      config.consumer_secret    = twitter.access_secret
      config.oauth_token        = authentication.access_token
      config.oauth_token_secret = authentication.access_secret
    end
    tweet = "#{feed.message}\n#{feed.link}"
    if feed.picture.present?
      uri = URI.parse(feed.picture)
      uri.open { |_media|
        # NOTE 直接_media(TempFileインスタンス)を渡すと、
        # update_with_mediaでエラー(Method missing original_filename)
        # が発生したので、暫定的にFileインスタンスに置き換える
        media = File.open(_media.path)
        if Twitter.update_with_media(tweet, media)
          reserve.update_attributes(posted_at: Time.now, tried_times: reserve.tried_times + 1)
        end
      }
    else
      if Twitter.update(tweet)
        reserve.update_attributes(posted_at: Time.now, tried_times: reserve.tried_times + 1)
      end
    end
  end
end

