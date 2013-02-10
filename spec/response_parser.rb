require 'spec_helper'

describe Hippie::ResponseParser do

  let(:response_txt) { File.open('./spec/fixtures/response.txt', 'r') }

  subject { Hippie::ResponseParser.new.parse(response_txt) }

  its(:code) { should == 200 }
  its(:header) { should be_a Hash }
  its(:body) { should be_a IO }
end

