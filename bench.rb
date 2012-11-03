require 'benchmark/ips'
require './lib/http2'

response = File.open 'spec/fixtures/response.txt', 'r'
parser = Http2::ResponseParser.new

Benchmark.ips do |ips|
  ips.report "parser" do
    response.rewind
    parser.parse response
  end
end

