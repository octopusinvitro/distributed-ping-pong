# frozen_string_literal: true

require 'connection'
require 'node_factory'
require 'parsers/arguments'
require 'ping_pong'
require 'ui'

require_relative 'factories'

RSpec.describe PingPong do
  let(:server) { Factories.server }
  let(:client) { Factories.client }

  let(:options) { Parsers::Arguments.new.parse([]) }
  let(:factory) { instance_double(NodeFactory, server:, client:) }
  let(:connection) { instance_double(Connection).as_null_object }

  subject(:ping_pong) { described_class.new(options, factory, connection, UI.new) }

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

    context 'when connected' do
      before { allow(connection).to receive(:connect_to_cluster).and_return(true) }

      it 'prints server id as server' do
        expect { ping_pong.play }.to output(/-1 as server/).to_stdout
      end

      it 'starts listening on the server' do
        ping_pong.play
        expect(connection).to have_received(:listen_to_cluster).with(server)
      end
    end

    context 'when not connected but server option' do
      before do
        allow(connection).to receive(:connect_to_cluster).and_return(false)
        options.server = true
      end

      it 'prints client id as server (after making client the server)' do
        expect { ping_pong.play }.to output(/#{client.id} as server/).to_stdout
      end

      it 'starts listening on the client' do
        ping_pong.play
        expect(connection).to have_received(:listen_to_cluster).with(client)
      end
    end

    context 'when not connected' do
      before { allow(connection).to receive(:connect_to_cluster).and_return(false) }

      it 'prints exit message with client id' do
        expect { ping_pong.play }.to output(/#{client.id}: Quitting/).to_stdout
      end
    end
  end
end
