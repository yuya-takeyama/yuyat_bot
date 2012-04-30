# coding: utf-8

class YuyatBot::TweetHandler::NothingToDo
  include YuyatBot::TweetHandlerHelper

  def call(tweet)
    reply_to tweet, 'ちょっと何言ってるかわからない'
  end
end
