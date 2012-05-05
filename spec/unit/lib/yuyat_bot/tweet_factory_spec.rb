describe YuyatBot::TweetFactory do
  let(:tweet_factory) { YuyatBot::TweetFactory.new(user_id: user_id) }
  let(:user_id) { 1 }
  let(:not_user_id) { 9999 }

  describe '#create' do
    subject { tweet_factory.create(input) }

    context 'when input has no text' do
      let(:input) { {} }
      it { should be_nil }
    end

    context 'when input has text' do
      let(:input) { {"text" => "foo"} }
      it { should be_a ::YuyatBot::Tweet }
    end

    context 'when in_reply_to_user_id is its user_id' do
      let(:input) { {'text' => 'foo', 'in_reply_to_user_id' => user_id} }
      it { should be_for_me }
    end

    context 'when in_reply_to_user_id is not its user_id' do
      let(:input) { {'text' => 'foo', 'in_reply_to_user_id' => not_user_id} }
      it { should_not be_for_me }
    end
  end
end
