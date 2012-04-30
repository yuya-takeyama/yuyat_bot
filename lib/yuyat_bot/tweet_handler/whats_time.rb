# coding: utf-8
require 'date'

class YuyatBot::TweetHandler::WhatsTime
  include YuyatBot::TweetHandlerHelper

  def call(tweet)
    if tweet.for_me?
      if tweet['text'] =~ /(いま|今)何時/
        reply_to tweet, "#{DateTime.now.to_s}"
        stop_tweet_handler
      end
    end
  end
end
