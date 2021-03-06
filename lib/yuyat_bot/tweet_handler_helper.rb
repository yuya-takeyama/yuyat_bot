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
  rescue ::Twitter::Error => e
    p e
    puts status
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
      if matches.respond_to? :size and matches.size == 2
        yield matches[1]
      elsif matches
        yield matches.to_a[1..-1]
      end
    end
  end

  def remove_at_marks(text)
    text.gsub(/@([a-zA-Z0-9]+)/, "\\1")
  end

  private
  def remove_header_screen_names(text)
    text.sub(/^(@[a-zA-Z1-9_]* *)/, '')
  end
end
