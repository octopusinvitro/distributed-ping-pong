# frozen_string_literal: true

require 'message'
require 'node'
require 'ui'

require_relative 'factories'

RSpec.describe UI do
  subject(:ui) { described_class.new }

  it 'prints node info' do
    node = Node.new(1, '127.0.0.1:8080')
    printed = "Node info: ID = 1, address = 127.0.0.1, port = 8080\n"
    expect { ui.print_node(node) }.to output(printed).to_stdout
  end

  it 'prints message info' do
    message = Message.new(Factories.client, Factories.server, 'hi')
    printed = /Message info: from = \d+, to = -1, contents = hi/
    expect { ui.print_message(message) }.to output(printed).to_stdout
  end

  it 'prints exit message' do
    expect { ui.print_exit(1) }.to output(/Node 1/).to_stdout
  end

  it 'prints is server message' do
    expect { ui.print_is_server(1) }.to output(/node 1/).to_stdout
  end

  it 'prints is connected message' do
    expect { ui.print_is_connected(1) }.to output(/1: Connected/).to_stdout
  end

  it 'prints connection error message' do
    error = StandardError.new('foo')
    expect { ui.print_connection_error(error, 1) }.to output(/foo.\nNode 1/).to_stdout
  end

  it 'prints listening error message' do
    error = StandardError.new('foo')
    expect { ui.print_listening_error(error, 1) }.to output(/foo.\nNode 1/).to_stdout
  end
end
