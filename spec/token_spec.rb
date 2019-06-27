RSpec.describe RubyRedtrack::Token do
  let(:params) do
    { 'token'               => 'JgiGYE0xryYCqmH4RnvdNK9rwrGmeQge',
      'expirationTimestamp' => '2017-07-01T21:15:41.253Z',
      'inaugural'           => false }
  end

  let(:token) { RubyRedtrack::Token.new(params) }

  describe '#expired?' do
    context 'when expirationTimestamp is in the future' do
      it 'returns false' do
        Timecop.freeze Time.new(2017, 7, 1, 21, 0, 0, '+00:00') do
          expect(token.expired?).to be false
        end
      end
    end

    context 'when expirationTimestamp is in the past' do
      it 'returns true' do
        Timecop.freeze Time.new(2017, 7, 1, 22, 0, 0, '+00:00') do
          expect(token.expired?).to be true
        end
      end
    end
  end
end
