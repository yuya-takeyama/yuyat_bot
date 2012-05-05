# coding: utf-8
class YuyatBot::TweetHandler::NothingToDo
  include YuyatBot::TweetHandlerHelper

  MESSAGES = [
    'えっ',
    'せやね',
    'せやな',
    'せやせや',
    'はい',
    'はいはい',
    'あーはいはい',
    'へぇ',
    'そうですね',
    'うん',
    'うんうん',
  ]

  def initialize
    @next = rand(MESSAGES.size)
  end

  def call(tweet)
    if tweet.for_me?
      reply_to tweet, message
      stop_tweet_handler
    end
  end

  def message
    result = MESSAGES[@next]
    @next += 1
    @next = 0 if @next > (MESSAGES.size - 1)
    result
  end
end
