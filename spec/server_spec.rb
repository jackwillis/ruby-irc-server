# typed: false
# frozen_string_literal: true

require_relative '../lib/irc/server'

RSpec.describe IRC::Server do
  let(:port) { 6667 }
  let(:server) { IRC::Server.new(port) }

  describe '#initialize' do
    it 'initializes with the given port' do
      expect(server.port).to eq(port)
    end
  end

  describe '#start and #stop' do
    it 'starts and stops the server' do
      expect { server.start }.not_to raise_error
      expect { server.stop }.not_to raise_error
    end
  end

  describe '#handle_client' do
    let(:mock_socket) { instance_double('TCPSocket') }

    before do
      allow(TCPSocket).to receive(:new).and_return(mock_socket)
      allow(mock_socket).to receive(:puts)
      allow(mock_socket).to receive(:gets).and_return("Hello\n", nil)
    end

    it 'echoes received messages' do
      expect(mock_socket).to receive(:puts).with('Echo: Hello')
      server.handle_client(mock_socket)
    end
  end
end
