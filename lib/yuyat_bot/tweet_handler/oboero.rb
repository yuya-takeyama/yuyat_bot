# coding: utf-8
require 'markovchain'
require 'markovchain-storage-mongodb'
require 'mongo'

class YuyatBot::TweetHandler::Oboero
  include YuyatBot::TweetHandlerHelper

  def initialize
    @markov = ::Markovchain.new(
      :state_size => 2,
      :storage    => Markovchain::Storage::MongoDb.new(
        :mongo      => Mongo::Connection.new,
        :db         => 'yuyat_bot',
        :collection => 'markovchain_corpus',
      )
    )
  end

  def call(tweet)
    reply_message_match tweet, /^(?:覚|憶|おぼ)え(?:て|ろ)(?:\s|　)(.*)$/ do |sequence|
      @markov.seed sequence
      reply_to tweet, "覚えた #{@markov.random_sequence}"
      stop_tweet_handler
    end
  end
end
