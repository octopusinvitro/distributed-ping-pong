# frozen_string_literal: true

require 'message'
require 'node_factory'

RSpec.describe Message do
  it 'has a JSON representation' do
    allow(Random).to receive(:rand).and_return(1)
    factory = NodeFactory.new
    message = Message.new(factory.client, factory.server, 'contents')

    hash = {
      join_cluster: {
        source: { id: 1, ip: '127.0.0.1', port: '8000' },
        destination: { id: -1, ip: '127.0.0.1', port: '8001' },
        contents: 'contents'
      }
    }
    expect(message.to_json).to eq(hash.to_json)
  end
end
