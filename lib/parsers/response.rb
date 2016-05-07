# frozen_string_literal: true

require 'json'

require_relative '../message'
require_relative '../node_factory'

module Parsers
  class Response
    def initialize(json)
      @response = JSON.parse(json, symbolize_names: true)
    end

    def message
      from = NodeFactory.new.from_hash(source)
      to = NodeFactory.new.from_hash(destination)

      Message.new(from, to, contents)
    end

    private

    attr_reader :response

    def source
      response[:join_cluster][:source]
    end

    def destination
      response[:join_cluster][:destination]
    end

    def contents
      response[:join_cluster][:contents]
    end
  end
end
