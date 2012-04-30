class YuyatBot::StopTweetHandlerException < StandardError; end

module YuyatBot::TweetHandlerHelper
  def twitter=(twitter)
    @twitter = twitter
  end

  def logger=(logger)
    @logger = logger
  end

  def tweet(status, options)
    @twitter.update(status, options)
  end

  def reply_to(tweet, status, options = {})
    options[:in_reply_to_status_id] = tweet['id']
    tweet("@#{tweet['user']['screen_name']} #{status}", options)
  end

  def stop_tweet_handler
    raise ::YuyatBot::StopTweetHandlerException
  end

  def reply_message_match(tweet, regexp, &block)
    if tweet.for_me?
      matches = remove_header_screen_names(tweet['text']).match regexp
      yield matches.to_a[1..-1] if matches
    end
  end

  private
  def remove_header_screen_names(text)
    text.sub(/^(@[a-zA-Z1-9_]* *)/, '')
  end
end
