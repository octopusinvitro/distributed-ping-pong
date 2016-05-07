# frozen_string_literal: true

require 'socket'

require 'connection'
require 'ui'

require_relative 'factories'

RSpec.describe Connection do
  subject(:connection) { described_class.new(UI.new) }

  let(:server_node) { Factories.server }
  let(:client_node) { Factories.client }

  before { allow($stdout).to receive(:puts) }

  describe '#connect_to_cluster' do
    let(:client) { instance_double(TCPSocket).as_null_object }

    before { allow(TCPSocket).to receive(:open).and_return(client) }

    it 'opens a client that connects to a node' do
      connection.connect_to_cluster(client_node, server_node)
      expect(TCPSocket).to have_received(:open).with(server_node.ip, server_node.port)
    end

    it 'prints connection success' do
      expect { connection.connect_to_cluster(client_node, server_node) }
        .to output(/Connected/).to_stdout
    end

    it 'sends request message' do
      connection.connect_to_cluster(client_node, server_node)
      expect(client).to have_received(:puts).with(/asking to join/)
    end

    it 'receives response message' do
      connection.connect_to_cluster(client_node, server_node)
      expect(client).to have_received(:gets)
    end

    it 'prints response message' do
      response_message = Message.new(client_node, server_node, 'contents')
      allow(client).to receive(:gets).and_return(response_message.to_json)
      expect { connection.connect_to_cluster(client_node, server_node) }
        .to output(/contents/).to_stdout
    end

    it 'returns true on success' do
      response_message = Message.new(client_node, server_node, 'contents')
      allow(client).to receive(:gets).and_return(response_message.to_json)
      expect(connection.connect_to_cluster(client_node, server_node)).to eq(true)
    end

    it 'prints errors if any' do
      allow(TCPSocket).to receive(:open).and_raise(StandardError.new('oh no'))
      expect { connection.connect_to_cluster(client_node, server_node) }
        .to output(/oh no/).to_stdout
    end

    it 'returns false on error' do
      allow(TCPSocket).to receive(:open).and_raise(StandardError.new('oh no'))
      expect(connection.connect_to_cluster(client_node, server_node)).to eq(false)
    end
  end

  describe '#listen_to_cluster' do
    let(:server) { instance_double(TCPServer).as_null_object }
    let(:client) { instance_double(TCPSocket).as_null_object }

    before do
      allow(TCPServer).to receive(:open).and_return(server)
      allow(server).to receive(:accept).and_return(client)

      request_message = Message.new(client_node, server_node, 'contents')
      allow(client).to receive(:gets).and_return(request_message.to_json)
    end

    it 'opens a server that accepts connections' do
      connection.listen_to_cluster(server_node)
      expect(TCPServer).to have_received(:open).with(server_node.ip, server_node.port)
    end

    it 'receives request message' do
      connection.listen_to_cluster(server_node)
      expect(client).to have_received(:gets)
    end

    it 'prints request message' do
      expect { connection.listen_to_cluster(server_node) }
        .to output(/contents/).to_stdout
    end

    it 'sends response message' do
      connection.listen_to_cluster(server_node)
      expect(client).to have_received(:puts).with(/has joined/)
    end

    it 'closes client on success' do
      connection.listen_to_cluster(server_node)
      expect(client).to have_received(:close).once
    end

    it 'closes server on success' do
      connection.listen_to_cluster(server_node)
      expect(server).to have_received(:close).once
    end

    it 'prints errors if any' do
      allow(TCPServer).to receive(:open).and_raise(StandardError.new('oh no'))
      expect { connection.listen_to_cluster(server_node) }
        .to output(/oh no/).to_stdout
    end
  end
end
