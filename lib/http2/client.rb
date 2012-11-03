module Http2
  class Client

    def get(url)
      Celluloid::Future.new do
	uri = URI(url)
	socket = TCPSocket.new uri.hostname, uri.port
	puts "client: writing request"
	socket.write "GET #{url} HTTP/1.1\r\n\r\n"
	puts "client: reading"
	Response.new socket
      end
    end
  end
end

