# frozen_string_literal: true

require 'node_factory'

RSpec.describe NodeFactory do
  subject(:factory) { described_class.new }

  let(:options) { Parsers::Options.default }

  describe '#server' do
    it 'sets id to default' do
      expect(factory.server.id).to eq(described_class::DEFAULT_SERVER_ID)
    end

    it 'sets address from default options' do
      expect(factory.server.address).to eq(options.address)
    end

    it 'can set address from custom options' do
      options.address = '1.2.3.4:5678'
      factory = described_class.new(options)
      expect(factory.server.address).to eq(options.address)
    end
  end

  describe '#client' do
    it 'sets id randomly' do
      allow(Random).to receive(:rand).and_return(1)
      expect(factory.client.id).to eq(1)
    end

    it 'sets address from machine with port from default options' do
      address = Addrinfo.new(Socket.sockaddr_in(0, '127.0.0.0'))
      allow(Socket).to receive(:ip_address_list).and_return([address])
      expect(factory.client.address).to eq("127.0.0.0:#{options.port}")
    end

    it 'can set address with port from custom options' do
      options.port = '1234'
      factory = described_class.new(options)
      expect(factory.client.address).to include(":#{options.port}")
    end
  end

  describe '#from_hash' do
    let(:hash) { { id: 1, ip: '0.0.0.0', port: '42' } }

    it 'sets id' do
      expect(factory.from_hash(hash).id).to eq(1)
    end

    it 'sets address' do
      expect(factory.from_hash(hash).address).to eq('0.0.0.0:42')
    end
  end
end
