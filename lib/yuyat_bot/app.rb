# coding:utf-8
require 'twitter'
require 'twitter/json_stream'
require 'multi_json'
require 'mongo'

module YuyatBot
  class App
    def initialize(config)
      @config = config
      @handlers = []

      Twitter.configure do |config|
        config.consumer_key       = @config['oauth']['consumer_key']
        config.consumer_secret    = @config['oauth']['consumer_secret']
        config.oauth_token        = @config['oauth']['access_key']
        config.oauth_token_secret = @config['oauth']['access_secret']
      end
      @twitter = Twitter

      @mongo = Mongo::Connection.new(@config['mongodb']['host'], @config['mongodb']['port'])
    end

    def configure
      enable! TweetHandler::WhatsTime
      enable! TweetHandler::Oboero, {
        :mongo      => @mongo,
        :db         => @config['mongodb']['database'],
        :collection => @config['oboero']['collection'],
      }
      enable! TweetHandler::NothingToDo
    end

    def enable!(klass, *options)
      handler = klass.new(*options)
      handler.twitter = @twitter
      @handlers.push handler
    end

    def start
      configure

      EventMachine::run {
        tweet_factory = ::YuyatBot::TweetFactory.new(user_id: @config['account']['user_id'].to_i)

        stream = Twitter::JSONStream.connect(
          host:    'userstream.twitter.com',
          path:    '/2/user.json',
          method:  'post',
          ssl:     true,
          oauth:   {
            consumer_key:    @config['oauth']['consumer_key'],
            consumer_secret: @config['oauth']['consumer_secret'],
            access_key:      @config['oauth']['access_key'],
            access_secret:   @config['oauth']['access_secret'],
          }
        )

        stream.each_item do |item|
          tweet = tweet_factory.create(item)
          if tweet
            @handlers.each do |handler|
              begin
                handler.call tweet
              rescue ::YuyatBot::StopTweetHandlerException
                break
              end
            end
          end
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
