# frozen_string_literal: true

require 'connection'
require 'node_factory'
require 'ping_pong'
require 'ui'

RSpec.describe PingPong do
  subject(:ping_pong) { described_class.new(factory, connection, UI.new) }

  let(:server) { NodeFactory.new.server }
  let(:client) { NodeFactory.new.client }
  let(:factory) { instance_double(NodeFactory, server:, client:) }
  let(:connection) { instance_double(Connection).as_null_object }

  before { allow($stdout).to receive(:puts) }

  describe '#play' do
    it 'creates server node' do
      ping_pong.play
      expect(factory).to have_received(:server)
    end

    it 'creates client node' do
      ping_pong.play
      expect(factory).to have_received(:client)
    end

    it 'prints client node information' do
      expect { ping_pong.play }.to output(/Node #{client.id}/).to_stdout
    end

    it 'tries to connect to the server node' do
      ping_pong.play
      expect(connection).to have_received(:connect_to_cluster).with(client, server)
    end

    it 'makes client the server and starts listening' do
      ping_pong.play
      expect(connection).to have_received(:listen_to_cluster).with(client)
    end
  end
end
