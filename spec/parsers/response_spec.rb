# frozen_string_literal: true

require 'message'
require 'parsers/response'

require_relative '../factories'

RSpec.describe Parsers::Response do
  describe '#message' do
    def response
      {
        join_cluster: {
          source: { id: 79_485_154, ip: '127.0.0.1', port: '8000' },
          destination: { id: -1, ip: '127.0.0.1', port: '8001' },
          contents: 'contents'
        }
      }
    end

    it 'parses a response into a message' do
      message = described_class.new(response).message
      expect(message.from.id).to eq(79_485_154)
      expect(message.to.id).to eq(-1)
      expect(message.contents).to eq('contents')
    end
  end
end
