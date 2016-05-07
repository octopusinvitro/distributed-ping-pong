# frozen_string_literal: true

require 'json'
require 'socket'

require_relative 'message'
require_relative 'parsers/response'

class Connection
  EXIT_CODE = 130

  def initialize(ui, maximum = 10)
    @ui = ui
    @maximum = maximum
    Thread.abort_on_exception = true
  end

  def connect_to_cluster(from, to)
    client = TCPSocket.open(to.ip, to.port)
    ui.print_is_connected(from.id, to.address)
    send_and_receive(client, from, to)
    client.close
  rescue StandardError => e
    ui.print_connection_error(e, from.id)
  end

  def listen_to_cluster(from)
    server = TCPServer.open(from.ip, from.port)
    ui.print_is_listening(from.id)
    receive_and_send(server, from)
    server.close
  rescue StandardError => e
    ui.print_listening_error(e, from.id)
  rescue Interrupt
    Kernel.exit(EXIT_CODE)
  end

  private

  attr_reader :ui, :maximum

  def send_and_receive(client, from, to)
    send(client, request_message(from, to))
    receive(client)
  end

  def receive_and_send(server, from)
    maximum.times do
      Thread.start(server.accept) do |client|
        to = receive(client)
        send(client, response_message(from, to))
        client.close
      end.join
    end
  end

  def send(client, message)
    client.puts(message.to_json)
  end

  def receive(client)
    message = Parsers::Response.new(client.gets).message
    ui.print_message(message)
    message.from
  end

  def request_message(from, to)
    Message.new(from, to, ui.request_contents(from))
  end

  def response_message(from, to)
    Message.new(from, to, ui.response_contents(to))
  end
end
