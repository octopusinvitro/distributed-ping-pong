# frozen_string_literal: true

require 'node'

RSpec.describe Node do
  subject(:node) { described_class.new(1, '127.0.0.1:8000') }

  it 'has an ip' do
    expect(node.ip).to eq('127.0.0.1')
  end

  it 'has an port' do
    expect(node.port).to eq('8000')
  end

  it 'has a hash representation' do
    expect(node.to_h).to eq(id: node.id, ip: node.ip, port: node.port)
  end
end
