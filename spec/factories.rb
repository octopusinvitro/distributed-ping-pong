# frozen_string_literal: true

require 'node_factory'
require 'parsers/options'

module Factories
  def self.server
    factory.server
  end

  def self.client
    factory.client
  end

  def self.factory
    NodeFactory.new(Parsers::Options.default)
  end
end
