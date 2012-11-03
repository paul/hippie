module Http2
  class Response
    attr_accessor :status, :headers, :body

    def initialize(io)
      puts "Response#initialize"
      ResponseParser.new.parse(io, self)
    end

    def headers
      @headers ||= {}
    end

  end
end

