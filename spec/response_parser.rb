require 'spec_helper'

describe Http2::ResponseParser do

  let(:response_txt) { File.open('./spec/fixtures/response.txt', 'r') }

  subject { Http2::ResponseParser.new.parse(response_txt) }

  its(:code) { should == 200 }
  its(:header) { should be_a Hash }
  its(:body) { should be_a IO }
end

