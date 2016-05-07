# frozen_string_literal: true

require 'node_factory'
require 'parsers/options'

RSpec.describe NodeFactory do
  let(:options) { Parsers::Options.default }
  let(:factory) { described_class.new(options, 42) }

  describe '#server' do
    it 'sets id to default' do
      expect(factory.server.id).to eq(described_class::DEFAULT_SERVER_ID)
    end

    it 'sets address from options' do
      expect(factory.server.address).to eq(options.address)
    end
  end

  describe '#client' do
    it 'sets id randomly' do
      expect(factory.client.id).to eq(65_682_867)
    end

    it 'can create several clients' do
      factory.client
      expect(factory.client.id).to eq(56_755_036)
    end

    it 'sets address with port from options' do
      address = Addrinfo.new(Socket.sockaddr_in(0, '127.0.0.0'))
      allow(Socket).to receive(:ip_address_list).and_return([address])
      expect(factory.client.address).to eq("127.0.0.0:#{options.port}")
    end
  end

  describe '#from_hash' do
    let(:node) { described_class.new.from_hash(id: 1, ip: '0.0.0.0', port: '42') }

    it 'sets id' do
      expect(node.id).to eq(1)
    end

    it 'sets address' do
      expect(node.address).to eq('0.0.0.0:42')
    end
  end
end
