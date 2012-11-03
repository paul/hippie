module Http2
  class Response
    attr_reader :code, :header, :body

    def initialize(code, header, body)
      @code, @header, @body = code, header, body
    end
  end
end

