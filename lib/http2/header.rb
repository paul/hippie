module Http2
  class Header < Hash

    class Value < String
      extend Forwardable
      array_methods = ([].methods - "".methods)
      def_delegators :values, *array_methods

      def self.new(value)
        return value if value.is_a? Value
        super
      end

      def values
        @values ||= self.split(',').map(&:strip)
      end

    end

    def initialize(headers = {})
      headers.is_a?(Hash) ? super : parse(headers)
    end

    def parse(io)
      io.each("\r\n") do |line|
        field, val = line.split(":")
        self[field] = val
      end
    end

    def [](field)
      super(canonicalize(field))
    end

    def []=(field, value)
      super(canonicalize(field), Value.new(value.strip))
    end

    module Util
      def canonicalize(field_name)
        field_name.to_s.downcase.tr('_', '-').split('-').map(&:capitalize).join('-')
      end
      module_function :canonicalize

      def methodize(field_name)
        field_name.to_s.downcase.tr('-', '_')
      end
      module_function :methodize
    end
    extend Util
    include Util

    GENERAL_HEADERS = %w[
      Cache-Control
      Connection
      Date
      Pragma
      Trailer
      Transfer-Encoding
      Upgrade
      Via
      Warning
    ]

    REQUEST_HEADERS = %w[
      Accept
      Accept-Charset
      Accept-Encoding
      Accept-Language
      Authorization
      Expect
      From
      Host
      If-Match
      If-Modified-Since
      If-None-Match
      If-Range
      If-Unmodified-Since
      Max-Forwards
      Proxy-Authorization
      Range
      Referer
      TE
      User-Agent
    ]

    RESPONSE_HEADERS = %w[
      Accept-Ranges
      Age
      ETag
      Location
      Proxy-Authenticate
      Retry-After
      Server
      Vary
      WWW-Authenticate
    ]

    ENTITY_HEADERS = %w[
      Allow
      Content-Encoding
      Content-Language
      Content-Length
      Content-Location
      Content-MD5
      Content-Range
      Content-Type
      Expires
      Last-Modified
    ]

    ALL_HEADERS = GENERAL_HEADERS + REQUEST_HEADERS + RESPONSE_HEADERS + ENTITY_HEADERS

    def self.compile_accessor(name)
      method_name = methodize(name)

      class_eval <<-RUBY, __FILE__, __LINE__
        def #{method_name}
          self["#{name}"]
        end

        def #{method_name}=(value)
          self["#{name}"] = value
        end
      RUBY
    end

    ALL_HEADERS.each do |name|
      compile_accessor(name)
      const_set name.upcase.tr('-', '_'), name
    end





  end
end

