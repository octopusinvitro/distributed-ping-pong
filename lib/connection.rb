# frozen_string_literal: true

require 'json'
require 'socket'

require_relative 'message'
require_relative 'parsers/response'

class Connection
  def initialize(ui)
    @ui = ui
  end

  def connect_to_cluster(from, to)
    client = TCPSocket.open(to.ip, to.port)
    ui.print_is_connected(from.id)

    send(client, from, to, request_contents(from))
    receive(client)

    true
  rescue StandardError => e
    ui.print_connection_error(e, from.id)
    false
  end

  def listen_to_cluster(from)
    server = TCPServer.open(from.ip, from.port)
    client = server.accept

    from, to = receive(client)
    send(client, from, to, response_contents(from))

    client.close
    server.close
  rescue StandardError => e
    ui.print_listening_error(e, from.id)
  end

  private

  attr_reader :ui

  def send(client, from, to, contents)
    message_out = Message.new(from, to, contents)
    client.puts(message_out.to_json)
  end

  def receive(client)
    response = JSON.parse(client.gets, symbolize_names: true)
    message_in = Parsers::Response.new(response).message
    ui.print_message(message_in)
    [message_in.from, message_in.to]
  end

  def request_contents(from)
    "Node #{from.id}: asking to join cluster"
  end

  def response_contents(from)
    "Node #{from.id}: has joined cluster"
  end
end
