require 'spec_helper'

require 'timeout'

describe Http2::Response, "IO operations" do

  before do
    @read, @write = IO.pipe
    @response = Http2::Response.new @read
  end

  describe "before connection established" do
    it "should block when investigating status" do
      -> { @response.raw_status }.should be_blocked
    end

    it "should block when investigating headers" do
      -> { @response.raw_header }.should be_blocked
    end

    it "should block when investigating body" do
      -> { @response.raw_body }.should be_blocked
    end
  end

  describe "after connection established, but before all headers received" do
    before do
      @write << "HTTP/1.1 200 OK\r\n"
      @write << "Content-Type: text/plain\r\n"
    end

    it "should block when investigating status" do
      -> { @response.raw_status }.should be_blocked
    end

    it "should block when investigating headers" do
      -> { @response.raw_header }.should be_blocked
    end

    it "should block when investigating body" do
      -> { @response.raw_body }.should be_blocked
    end
  end

  describe "after all headers received" do
    before do
      @write << "HTTP/1.1 200 OK\r\n"
      @write << "Content-Type: text/plain\r\n"
      @write << "Content-Length: 100\r\n"
      @write << "\r\n"
    end

    it "should not block when investigating status" do
      -> { @response.raw_status }.should_not be_blocked
    end

    it "should not block when investigating headers" do
      -> { @response.raw_header }.should_not be_blocked
    end

    it "should not block when investigating body" do
      -> { @response.raw_body }.should_not be_blocked
    end
  end

  def be_blocked
    Class.new do
      include Timeout
      def matches?(block)
        @block = block
        timeout(0.1, &block)
        false
      rescue Timeout::Error
        true
      end

      def failure_message
        %{Expected #{@block.inspect} to be blocked}
      end

      def negative_failure_message
        %{Expected #{@block.inspect} to not be blocked}
      end
    end.new
  end

end

