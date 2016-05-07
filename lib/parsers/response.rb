# frozen_string_literal: true

require_relative '../node_factory'

module Parsers
  class Response
    def initialize(response)
      @response = response
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
