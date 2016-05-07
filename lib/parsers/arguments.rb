# frozen_string_literal: true

require 'ipaddr'
require 'optparse'

require_relative 'options'

module Parsers
  class Arguments
    MESSAGES = {
      banner: 'Usage: ruby bin/app [options]',
      help: 'Prints this help.',
      server: 'Make this node server if unable to connect to provided address.',
      address: "IP:port of the node to connnect to. Default is #{Options.default.address}.",
      port: "Port to run this node on. Default is #{Options.default.port}."
    }.freeze

    def initialize(kernel = Kernel)
      @parser = OptionParser.new
      @options = Options.default
      @kernel = kernel

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

    attr_reader :parser, :options, :kernel

    def setup_parser
      set_banner
      read_help
      read_server
      read_address
      read_port
    end

    def set_banner
      parser.banner = MESSAGES[:banner]
    end

    def read_help
      parser.on('-h', '--help', MESSAGES[:help]) { print_help }
    end

    def read_server
      parser.on('-s', '--[no-]server', MESSAGES[:server]) do |value|
        options.server = value
      end
    end

    def read_address
      parser.on('-a ADDRESS', '--address=ADDRESS', MESSAGES[:address]) do |value|
        ip, port = value.split(':')
        options.address = [IPAddr.new(ip), Integer(port)].join(':')
      end
    end

    def read_port
      parser.on('-p PORT', '--port=PORT', MESSAGES[:port]) do |value|
        options.port = Integer(value).to_s
      end
    end

    def print_help
      puts(parser)
      kernel.exit
    end
  end
end
