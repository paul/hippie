require 'spec_helper'

describe Http2::Header do

  describe "setting values" do

  end

  describe "reading values" do

    let(:header) { Http2::Header.new }
    subject { header }

    it "should handle case-insensitive lookups" do
      header["Content-Type"] = "text/plain"

      header["Content-Type"].should              == "text/plain"
      header["content_type"].should              == "text/plain"
      header[:content_type].should               == "text/plain"
      header.content_type.should                 == "text/plain"
      header[Http2::Header::CONTENT_TYPE].should == "text/plain"
    end

  end

  describe "parsing from string" do

  end

  describe "converting to string" do

  end

end

