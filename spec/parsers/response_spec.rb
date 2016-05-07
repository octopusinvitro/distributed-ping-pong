# frozen_string_literal: true

require 'parsers/response'

RSpec.describe Parsers::Response do
  describe '#message' do
    def json
      {
        join_cluster: {
          source: { id: 1, ip: '127.0.0.1', port: '8000' },
          destination: { id: -1, ip: '127.0.0.1', port: '8001' },
          contents: 'contents'
        }
      }.to_json
    end

    it 'parses JSON into a message' do
      allow(Random).to receive(:rand).and_return(1)
      message = described_class.new(json).message

      expect(message.from.id).to eq(1)
      expect(message.to.id).to eq(-1)
      expect(message.contents).to eq('contents')
    end
  end
end
