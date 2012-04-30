module YuyatBot
  class Tweet
    def initialize(tweet, options = {})
      @tweet = tweet
      @for_me = options[:for_me] || false
    end

    def for_me?
      @for_me
    end
  end
end
