module Http2
  class ResponseParser
    CRLF  = "\\r\\n"
    SP    = " "
    COLON = ":"

    def parse(io)
      status_line = io.gets(CRLF)
      version, status_code, reason_phrase = status_line.split(SP)
      status_code = Integer(status_code)

      headers = {}
      while line = io.gets(CRLF)
        k, v = *line.split(COLON)
        headers[k] = v.rtrim
      end

      body = io

      Response.new(status_code, headers, io)
    end
  end
end

