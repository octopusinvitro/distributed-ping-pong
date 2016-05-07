# frozen_string_literal: true

require 'parsers/arguments'

RSpec.describe Parsers::Arguments do
  let(:parser) { described_class.new }

  describe '#parse' do
    context 'on help' do
      let(:kernel_double) { double(Kernel, exit: nil) }
      let(:parser) { described_class.new(kernel_double) }

      it 'prints a banner' do
        expect { parser.parse(['-h']) }.to output(/Usage/).to_stdout
      end

      it 'exits the program' do
        allow($stdout).to receive(:puts)
        parser.parse(['-h'])
        expect(kernel_double).to have_received(:exit)
      end
    end

    context 'on server' do
      it 'can set it' do
        options = parser.parse(['-s'])
        expect(options.server).to eq(true)
      end

      it 'can unset it' do
        options = parser.parse(['--no-server'])
        expect(options.server).to eq(false)
      end

      it 'is not set by default' do
        options = parser.parse([])
        expect(options.server).to eq(false)
      end
    end

    context 'on address' do
      it 'can set it' do
        options = parser.parse(['-a', '1.2.3.4:42'])
        expect(options.address).to eq('1.2.3.4:42')
      end

      it 'sets one by default if not provided' do
        options = parser.parse([])
        expect(options.address).to eq('127.0.0.1:8001')
      end
    end

    context 'on port' do
      it 'can set it' do
        options = parser.parse(['-p', '42'])
        expect(options.port).to eq('42')
      end

      it 'sets one by default if not provided' do
        options = parser.parse([])
        expect(options.port).to eq('8000')
      end
    end

    context 'when error' do
      let(:kernel_double) { double(Kernel, exit: nil) }
      let(:parser) { described_class.new(kernel_double) }

      before { allow($stdout).to receive(:puts) }

      it 'informs of missing argument' do
        expect { parser.parse(['-a']) }.to output(/missing/).to_stdout
      end

      it 'informs of invalid address IP' do
        expect { parser.parse(['-a', 'not.an.ip:8080']) }.to output(/invalid/).to_stdout
      end

      it 'informs of invalid address port' do
        expect { parser.parse(['-a', '127.0.0.1:lol']) }.to output(/invalid/).to_stdout
      end

      it 'informs of invalid port' do
        expect { parser.parse(['-p', 'notaport']) }.to output(/invalid/).to_stdout
      end

      it 'prints help' do
        expect { parser.parse(['-a']) }.to output(/Usage/).to_stdout
      end

      it 'exits the program' do
        parser.parse(['-p'])
        expect(kernel_double).to have_received(:exit)
      end
    end
  end
end
