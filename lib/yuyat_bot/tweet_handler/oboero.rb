# coding: utf-8
require 'markovchain'

class YuyatBot::TweetHandler::Oboero
  include YuyatBot::TweetHandlerHelper

  def initialize
    @markov = Markovchain.new 2
  end

  def call(tweet)
    reply_message_match tweet, /^(?:覚|憶|おぼ)え(?:て|ろ)(?:\s|　)(.*)$/ do |sequence|
      @markov.seed sequence
      reply_to tweet, "覚えた #{@markov.random_sequence}"
      stop_tweet_handler
    end
  end
end
