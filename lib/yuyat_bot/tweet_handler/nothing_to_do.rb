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
    reply_to tweet, message if tweet.for_me?
  end

  def message
    result = MESSAGES[@next]
    @next += 1
    @next = 0 if @next > (MESSAGES.size - 1)
    result
  end
end
