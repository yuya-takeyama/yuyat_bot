module YuyatBot
  autoload :App, 'yuyat_bot/app'
  autoload :Tweet, 'yuyat_bot/tweet'
  autoload :TweetFactory, 'yuyat_bot/tweet_factory'
  module TweetHandler
    autoload :NothingToDo, 'yuyat_bot/tweet_handler/nothing_to_do'
  end
  autoload :TweetHandler, 'yuyat_bot/tweet_handler'
  autoload :TweetHandlerHelper, 'yuyat_bot/tweet_handler_helper'
end
autoload :YuyatBot, 'yuyat_bot'
