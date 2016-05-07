# frozen_string_literal: true

require 'connection'
require 'node_factory'
require 'ui'

RSpec.describe Connection do
  subject(:connection) { described_class.new(UI.new, 1) }

  let(:server_node) { NodeFactory.new.server }
  let(:client_node) { NodeFactory.new.client }

  before { allow($stdout).to receive(:puts) }

  describe '#connect_to_cluster' do
    let(:client) { instance_double(TCPSocket).as_null_object }

    before do
      allow(TCPSocket).to receive(:open).and_return(client)

      response_message = Message.new(client_node, server_node, 'contents')
      allow(client).to receive(:gets).and_return(response_message.to_json)
    end

    it 'opens a client that connects to a node' do
      connection.connect_to_cluster(client_node, server_node)
      expect(TCPSocket).to have_received(:open).with(server_node.ip, server_node.port)
    end

    it 'prints connection success' do
      expect { connection.connect_to_cluster(client_node, server_node) }
        .to output(/#{client_node.id} established connection/).to_stdout
    end

    it 'sends request message' do
      connection.connect_to_cluster(client_node, server_node)
      expect(client).to have_received(:puts).with(/#{client_node.id} is asking to join/)
    end

    it 'receives response message' do
      connection.connect_to_cluster(client_node, server_node)
      expect(client).to have_received(:gets).once
    end

    it 'prints response message' do
      expect { connection.connect_to_cluster(client_node, server_node) }
        .to output(/contents/).to_stdout
    end

    it 'closes client on success' do
      connection.connect_to_cluster(client_node, server_node)
      expect(client).to have_received(:close).once
    end

    it 'prints errors if any' do
      allow(TCPSocket).to receive(:open).and_raise(StandardError.new('oh no'))
      expect { connection.connect_to_cluster(client_node, server_node) }
        .to output(/oh no/).to_stdout
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

    it 'prints server id as server' do
      expect { connection.listen_to_cluster(server_node) }
        .to output(/#{server_node.id} is now a server/).to_stdout
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
      expect(client).to have_received(:puts).with(/#{client_node.id} has joined/)
    end

    it 'closes client on success' do
      connection.listen_to_cluster(server_node)
      expect(client).to have_received(:close).once
    end

    it 'closes server on success' do
      connection.listen_to_cluster(server_node)
      expect(server).to have_received(:close).once
    end

    it 'accepts a maximum number of connections' do
      maximum = 2
      described_class.new(UI.new, maximum).listen_to_cluster(server_node)
      expect(client).to have_received(:close).exactly(maximum).times
      expect(server).to have_received(:close).once
    end

    it 'prints errors if any' do
      allow(TCPServer).to receive(:open).and_raise(StandardError.new('oh no'))
      expect { connection.listen_to_cluster(server_node) }
        .to output(/oh no/).to_stdout
    end

    it 'captures user interruption' do
      ui = instance_double(UI).as_null_object
      allow(ui).to receive(:print_is_listening).and_raise(Interrupt.new)

      allow(Kernel).to receive(:exit)
      described_class.new(ui).listen_to_cluster(server_node)
      expect(Kernel).to have_received(:exit).with(described_class::EXIT_CODE)
    end
  end
end
