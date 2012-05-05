class YuyatBot::CodeBlockEvaluatedException < StandardError; end

describe YuyatBot::TweetHandlerHelper do
  include YuyatBot::TweetHandlerHelper

  describe '#reply_message_match' do
    it 'should call code block if message matched' do
      lambda {
        tweet = ::YuyatBot::Tweet.new({"text" => "@yuyat_bot 1 2 3"}, :for_me => true)
        reply_message_match tweet, /^(\d) (\d) (\d)/ do |n1, n2, n3|
          n1.should == "1"
          n2.should == "2"
          n3.should == "3"
          raise YuyatBot::CodeBlockEvaluatedException
        end
      }.should raise_error(::YuyatBot::CodeBlockEvaluatedException)
    end

    it 'should pass one String argument' do
      lambda {
        tweet = ::YuyatBot::Tweet.new({"text" => "@yuyat_bot foo bar"}, :for_me => true)
        reply_message_match tweet, /^(?:[^\s]+) (.*)$/ do |message|
          message.should == "bar"
          raise YuyatBot::CodeBlockEvaluatedException
        end
      }.should raise_error(::YuyatBot::CodeBlockEvaluatedException)
    end

    it 'should not call code block if message not matched' do
      lambda {
        tweet = ::YuyatBot::Tweet.new({"text" => "1 2 3"}, :for_me => true)
        reply_message_match tweet, /abc/ do |m|
          raise YuyatBot::CodeBlockEvaluatedException
        end
      }.should_not raise_error(::YuyatBot::CodeBlockEvaluatedException)
    end
  end
end
