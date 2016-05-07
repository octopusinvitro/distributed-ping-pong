# frozen_string_literal: true

require 'message'
require 'node_factory'
require 'ui'

RSpec.describe UI do
  subject(:ui) { described_class.new }

  it 'prints node info' do
    node = NodeFactory.new.server
    printed = "Node -1 at 127.0.0.1:8001\n"
    expect { ui.print_node(node) }.to output(printed).to_stdout
  end

  it 'prints message info' do
    address = Addrinfo.new(Socket.sockaddr_in(0, '127.0.0.1'))
    allow(Socket).to receive(:ip_address_list).and_return([address, address])

    factory = NodeFactory.new
    message = Message.new(factory.client, factory.server, 'hi')
    printed = %(
      Message info:
        from: node at 127.0.0.1:8000
        to:   node at 127.0.0.1:8001
        contents: "hi"
    )
    expect { ui.print_message(message) }.to output(/#{printed}/).to_stdout
  end

  it 'prints is listening message' do
    expect { ui.print_is_listening(1) }.to output(/Node 1/).to_stdout
  end

  it 'prints is connected message' do
    expect { ui.print_is_connected(1, '1.2.3.4:5678') }
      .to output(/1 established connection with 1.2.3.4:5678/).to_stdout
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
