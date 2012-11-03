require 'spec_helper'

require 'timeout'

describe "concurrency" do

  def be_blocked
    Class.new do
      def matches?(block)
	Timeout::timeout(0.1) { puts "start block"; Thread.new &block }
	true
      rescue Timeout::Error
	false
      end
    end.new
  end

  it "should work" do
    server = TCPServer.new '127.0.0.1', 18089

    client = Http2::Client.new

    response = client.get 'http://127.0.0.1:18089/'
    p response

    -> { response.status }.should be_blocked

    s = server.accept
    puts "server: start writing"
    s.write "HTTP/1.1 200 Ok\r\n"
    puts "server: status line wrote"

    hello = "Hello, World!"
    s.write "Content-Type: text/plain\r\n"
    s.write "Content-Length: #{hello.size}\r\n\r\n"

    puts "server: headers wrote"
    response.value.status.should == 200
    p response.value.headers
    response.value.headers.should have_key "Content-Type"

    response.value.body.should be_blocked

    s.write hello

    response.body.should == hello
  end
end

