describe YuyatBot::TweetFactory do
  let(:tweet_factory) { YuyatBot::TweetFactory.new(user_id: user_id) }
  let(:user_id) { 1 }

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
  end
end
