# frozen_string_literal: true

require_relative 'connection'
require_relative 'node_factory'
require_relative 'parsers/arguments'

class PingPong
  def initialize(options, factory, connection, ui)
    @options = options
    @factory = factory
    @connection = connection
    @ui = ui
  end

  def play
    create_nodes
    connected = connected?
    return print_exit unless connected || options.server

    @server = client if !connected && options.server
    detect_nodes
  end

  private

  attr_reader :options, :factory, :connection, :ui, :server, :client

  def create_nodes
    @server = factory.server
    @client = factory.client
    ui.print_node(server)
    ui.print_node(client)
  end

  def print_exit
    ui.print_exit(client.id)
  end

  def connected?
    connection.connect_to_cluster(client, server)
  end

  def detect_nodes
    ui.print_is_server(server.id)
    connection.listen_to_cluster(server)
  end
end
