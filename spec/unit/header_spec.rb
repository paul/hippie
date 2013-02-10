require 'spec_helper'

describe Hippie::Header do

  describe "setting values" do

  end

  describe "reading values" do

    let(:header) { Hippie::Header.new }
    subject { header }

    it "should handle case-insensitive lookups" do
      header["Content-Type"] = "text/plain"

      header["Content-Type"].should              == "text/plain"
      header["content_type"].should              == "text/plain"
      header[:content_type].should               == "text/plain"
      header.content_type.should                 == "text/plain"
      header[Hippie::Header::CONTENT_TYPE].should == "text/plain"
    end

    describe "with multiple values" do
      before do
        header["Accept"] = "application/json, text/plain"
      end

      it "should be readable as a string" do
        header["Accept"].should == "application/json, text/plain"
      end

      it "should be usable as an array" do
        header["Accept"].first.should == "application/json"
      end

    end


  end

  describe "parsing from io" do
    let(:header_str) { StringIO.new(<<-STR.gsub("\n", "\r\n")) }
User-Agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
If-Modified-Since:Thu, 24 Jan 2013 06:46:49 GMT
If-None-Match:"6b140c-14e92-4d4032cd52840"
STR
    let(:header) { Hippie::Header.new(header_str) }

    it "should have normal string headers as text" do
      header["User-Agent"].should == "curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5"
    end

    it "should have multiple values as iterable objects" do
      header["Accept"].first.should == "text/html"
    end

    it "should not unquote quoted values" do
      header["If-None-Match"].should == '"6b140c-14e92-4d4032cd52840"'
    end

  end

  describe "converting to io" do

  end

end

