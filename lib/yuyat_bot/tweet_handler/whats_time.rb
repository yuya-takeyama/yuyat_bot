# coding: utf-8
require 'date'

class YuyatBot::TweetHandler::WhatsTime
  include YuyatBot::TweetHandlerHelper

  def call(tweet)
    reply_message_match tweet, /^(いま|今)何時/ do
      reply_to tweet, "#{DateTime.now.to_s}"
      stop_tweet_handler
    end
  end
end
