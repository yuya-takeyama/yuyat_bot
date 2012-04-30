describe YuyatBot::Tweet do
  describe '#[]' do
    subject { YuyatBot::Tweet.new(input) }

    context 'input is valid tweet hash' do
      let(:input) { {"text" => "foo"} }

      its(["text"]) { should == "foo" }
    end
  end
end
