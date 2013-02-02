module Http2
  class Response
    attr_reader :state

    def initialize(io)
      @io = io
      @future = Celluloid::Future.new { parse_response! }
    end

    def status
      raw_status.split(' ')[1]
    end

    def raw_status
      @raw_status ||= @future.value[0]
    end

    def raw_header
      @raw_header ||= @future.value[1]
    end

    def raw_body
      @raw_body ||= @future.value[2]
    end

    # private-ish

    def parse_response!
      # First line is the status line
      status_txt = @io.gets

      # Then, headers till we get a blank line
      header_txt = ""
      until (line = @io.gets.strip) == ""
        header_txt << line =@io.gets
      end

      [status_txt, header_txt, @io]
    end

  end
end

