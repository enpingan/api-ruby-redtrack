RSpec.describe RubyRedtrack::Client do
  let(:client) do
    VCR.use_cassette('login_with_email') do
      RubyRedtrack::Client.new(login: 'good@good.com', password: '12345678')
    end
  end

  describe '#initialize' do
    it 'returns a RubyRedtrack::Client instance' do
      expect(client).to be_instance_of RubyRedtrack::Client
    end
  end

  describe '#report' do
    subject { client.report }

    it 'returns a RubyRedtrack::Report instance' do
      expect(subject).to be_instance_of RubyRedtrack::Report
    end
  end
end
