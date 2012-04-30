# coding:utf-8
require 'twitter/json_stream'
require 'multi_json'

module YuyatBot
  class App
    def self.start(config)
      EventMachine::run {
        tweet_factory = ::YuyatBot::TweetFactory.new(user_id: config['account']['user_id'].to_i)

        stream = Twitter::JSONStream.connect(
          host:    'userstream.twitter.com',
          path:    '/2/user.json',
          method:  'post',
          ssl:     true,
          oauth:   {
            consumer_key:    config['oauth']['consumer_key'],
            consumer_secret: config['oauth']['consumer_secret'],
            access_key:      config['oauth']['access_key'],
            access_secret:   config['oauth']['access_secret'],
          }
        )

        stream.each_item do |item|
          p MultiJson.decode(item)
          #tweet = tweet_factory.create(item)
        end

        stream.on_error do |message|
          $stdout.print "error: #{message}\n"
          $stdout.flush
        end

        stream.on_reconnect do |timeout, retires|
          $stdout.print "reconnecting in: #{timeout} seconds\n"
          $stdout.flush
        end

        stream.on_max_reconnects do |timeout, retires|
          $stdout.print "Failed after #{retries} failed reconnects\n"
          $stdout.flush
        end

        trap('TERM') {
          stream.stop
          EventMachine.stop if EventMachine.reactor_running?
        }
      }
    end
  end
end
