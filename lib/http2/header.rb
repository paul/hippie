module Http2
  class Header < Hash

    class Field < String

      def self.new(field)
        return field if field.is_a? Field
        super
      end

      def initialize(string)
        super(canonicalize(string))
      end

      def eql?(other)
        case other
        when Field then super(other)
        when String, Symbol then super(self.new(other))
        else false
        end
      end
      alias == eql?

      # The pretty HTTP-Spec style header field name
      # e.g., "Content-Type"
      def canonicalize(string)
        string.to_s.downcase.tr('_', '-').split('-').map(&:capitalize).join('-')
      end

    end

    def [](field)
      super(Field.new(field))
    end

    def []=(field, value)
      super(Field.new(field), value)
    end

    module Util
      def canonicalize(field_name)
        field_name.to_s.downcase.tr('_', '-').split('-').map(&:capitalize).join('-')
      end

      def methodize(field_name)
        field_name.to_s.downcase.tr('-', '_')
      end
    end
    extend Util

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
    ].map { |f| Field.new(f) }

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
    ].map { |f| Field.new(f) }

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
    ].map { |f| Field.new(f) }

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
    ].map { |f| Field.new(f) }

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

