# frozen_string_literal: true

require 'socket'

module IRC

  class Server
    attr_reader :port

    def initialize(port)
      @port = port
    end

    def start
      ServerActor.new(self).start
    end
  end

  class ServerActor
    def initialize(server)
      @server = server
    end

    def start
      Ractor.new(@server) do |server|
        tcp_server = TCPServer.new(server.port)

        loop do
          socket = tcp_server.accept
          ClientActor.new(socket).start
        end
      end
    end
  end

  class ClientActor
    def initialize(socket)
      @socket = socket
    end

    def start
      Ractor.new(@socket) do |socket|
        loop do
          message = socket.gets.chomp
          socket.puts "Echo: #{message}"
        end
      ensure
        socket.close
      end
    end
  end

end
