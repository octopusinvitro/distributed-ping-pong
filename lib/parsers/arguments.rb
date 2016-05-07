# frozen_string_literal: true

require 'ipaddr'
require 'optparse'

require_relative 'options'

module Parsers
  class Arguments
    MESSAGES = {
      banner: "\nUsage: ruby bin/app [options]",
      help: 'Prints this help.',
      address: "IP:port of the node to connect to. Default is #{Options.default.address}.",
      port: "Port to run this node on. Default is #{Options.default.port}."
    }.freeze

    def initialize
      @parser = OptionParser.new
      @options = Options.default

      setup_parser
    end

    def parse(arguments)
      parser.parse!(arguments)
      options
    rescue StandardError => e
      puts("ERROR: #{e.message}\n\n")
      print_help
    end

    private

    attr_reader :parser, :options

    def setup_parser
      set_banner
      read_help
      read_address
      read_port
    end

    def set_banner
      parser.banner = MESSAGES[:banner]
    end

    def read_help
      parser.on('-h', '--help', MESSAGES[:help]) { print_help }
    end

    def read_address
      parser.on('-a ADDRESS', '--address=ADDRESS', MESSAGES[:address]) do |address|
        ip, port = address.split(':')
        options.address = [IPAddr.new(ip), Integer(port)].join(':')
      end
    end

    def read_port
      parser.on('-p PORT', '--port=PORT', MESSAGES[:port]) do |port|
        options.port = Integer(port).to_s
      end
    end

    def print_help
      puts(parser)
      Kernel.exit
    end
  end
end
