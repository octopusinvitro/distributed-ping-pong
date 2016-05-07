# frozen_string_literal: true

require 'message'
require 'node'

RSpec.describe Message do
  it 'has a JSON representation' do
    from = Node.new(1, '2:3')
    to = Node.new(4, '5:6')
    message = Message.new(from, to, 'message')

    hash = {
      join_cluster: {
        source: from.to_h,
        destination: to.to_h,
        contents: 'message'
      }
    }
    expect(message.to_json).to eq(hash.to_json)
  end
end
