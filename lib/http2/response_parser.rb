require 'celluloid'

module Http2
  class ResponseParser
    CRLF  = "\r\n"
    SP    = " "
    COLON = ":"

    def parse(io, response)
      puts "parse start"

      str = io.readpartial(1024)
      puts str
      status_line, str = str.split(CRLF, 2)

      version, status_code, reason_phrase = status_line.split(SP)
      response.status = Integer(status_code)

      until str.index(CRLF + CRLF)
        while str.index(CRLF)
          line, str = str.split(CRLF, 2)
          puts line
          k, v = *line.split(COLON)
          response.headers[k] = v.trim
        end

        str << io.readpartial(1024)
      end

      response.body = io
      puts "parse done"
      response
    end
  end
end

