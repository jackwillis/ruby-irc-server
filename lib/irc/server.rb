# frozen_string_literal: true

require 'socket'

module IRC
  class Server
    def initialize(port)
      @server = TCPServer.new(port)
      start
    end

    private

    def start
      loop do
        client = @server.accept
        Ractor.new(client) do |client_conn|
          message = client_conn.gets
          client_conn.puts "Echo: #{message}"
        ensure
          client_conn.close
        end
      end
    end
  end

end
