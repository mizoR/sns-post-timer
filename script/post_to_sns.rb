#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'open-uri'

puts "== Start #{Time.now}"

MAX_TRIED_TIMES = 3

reserves = Reserve.where('posted_at IS NULL AND posts_at <= ? AND tried_times < ?', Time.now, MAX_TRIED_TIMES)
reserves.each do |reserve|
  feed = reserve.feed
  authentication = reserve.authentication

  puts "= feed          : #{feed.to_json}"
  puts "= reserve       : #{reserve.to_json}"
  puts "= authentication: #{authentication.to_json}"

  reserve.update_column(:tried_times, reserve.tried_times + 1)

  case authentication.service_type
  when 'facebook'
    params = {
      message:     feed.message,
      picture:     feed.picture,
      link:        feed.link,
      name:        feed.name,
      description: feed.description }
    if authentication.facebook.feed!(params)
      reserve.update_column(:posted_at, Time.now)
    end
  when 'twitter'
    Twitter.configure do |config|
      twitter = Settings.web_services.twitter
      config.consumer_key       = twitter.access_token
      config.consumer_secret    = twitter.access_secret
      config.oauth_token        = authentication.access_token
      config.oauth_token_secret = authentication.access_secret
    end

    tweet = "#{feed.message}\n#{feed.link}"
    if feed.picture.present?
      uri = URI.parse(feed.picture)
      begin
        media = uri.open
        case media
        when StringIO
          type = media.content_type.gsub(/image\//, '')
          Twitter.update_with_media(tweet, { io: _media, type: type })
          reserve.update_column(:posted_at, Time.now)
        when File, Tempfile
          puts media.path
          Twitter.update_with_media(tweet, File.new(media.path))
          reserve.update_column(:posted_at, Time.now)
        else
          puts 'Media not found.'
        end
      rescue => e
        puts "Error: #{e.message}"
        puts "Backtrace:\n#{e.backtrace.join("\n")}"
      ensure
        media.close if media
      end
    else
      if Twitter.update(tweet)
        reserve.update_column(:posted_at, Time.now)
      end
    end
  end
end

puts "== Finish #{Time.now}"

exit 0
