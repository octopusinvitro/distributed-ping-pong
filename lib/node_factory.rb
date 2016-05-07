# frozen_string_literal: true

require 'socket'

require_relative 'node'

class NodeFactory
  DEFAULT_SERVER_ID = -1

  def initialize(options = nil, seed = Time.now.utc.to_i)
    @options = options
    @random = Random.new(seed)
  end

  def server
    Node.new(DEFAULT_SERVER_ID, options.address)
  end

  def client
    Node.new(node_id, node_address)
  end

  def from_hash(hash)
    Node.new(hash[:id], join(hash[:ip], hash[:port]))
  end

  private

  attr_reader :options, :random

  def node_id
    random.rand(99_999_999)
  end

  def node_address
    ip = Socket.ip_address_list.first.ip_address
    port = options.port
    join(ip, port)
  end

  def join(ip, port)
    [ip, port].join(':')
  end
end
