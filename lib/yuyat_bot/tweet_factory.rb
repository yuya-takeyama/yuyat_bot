require 'multi_json'

module YuyatBot
  class TweetFactory
    def initialize(options = {})
      @user_id = options[:user_id]
    end

    def create(tweet)
      tweet = MultiJSON.decode(tweet) if tweet.is_a? String
      if tweet.key? 'text'
        ::YuyatBot::Tweet.new(tweet,
          for_me: (tweet.key? 'in_reply_to_user_id' and @user_id == tweet['in_reply_to_user_id'])
        )
      end
    end
  end
end
