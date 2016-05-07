# frozen_string_literal: true

require 'socket'

require_relative 'node'
require_relative 'parsers/options'

class NodeFactory
  DEFAULT_SERVER_ID = -1

  def initialize(options = Parsers::Options.default)
    @options = options
  end

  def server
    Node.new(DEFAULT_SERVER_ID, options.address)
  end

  def client
    Node.new(id, address)
  end

  def from_hash(hash)
    Node.new(hash[:id], join(hash[:ip], hash[:port]))
  end

  private

  attr_reader :options

  def id
    Random.rand(99_999_999)
  end

  def address
    ip = Socket.ip_address_list[1].ip_address
    port = options.port
    join(ip, port)
  end

  def join(ip, port)
    [ip, port].join(':')
  end
end
