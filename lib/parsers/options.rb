# frozen_string_literal: true

module Parsers
  Options = Struct.new(:server, :address, :port) do
    def self.default
      new(false, '127.0.0.1:8001', '8000')
    end
  end
end
