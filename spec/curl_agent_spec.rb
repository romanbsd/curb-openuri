require File.dirname(__FILE__) + '/spec_helper'

describe "CurlAgent" do

  describe 'new method' do
    it 'shall permit to override user-agent' do
      curl = CurlAgent.new('http://www.example.com/')
      curl.headers['User-Agent'].should_not be_nil
      curl.headers['User-Agent'] = 'curl'
      curl.headers['User-Agent'].should == 'curl'
    end
  end

  describe 'when used alone' do
    before(:each) do
      @mock = mock('curl_easy')
      @headers = {'User-Agent' => 'foo'}
      @mock.stub!(:headers).and_return(@headers)
      @mock.stub!(:'follow_location=')
      @mock.stub!(:'max_redirects=')
      @mock.stub!(:'enable_cookies=')
      @mock.stub!(:'connect_timeout=')
      @mock.stub!(:'timeout=')
      @mock.should_receive(:perform)
      Curl::Easy.should_receive(:new).and_return(@mock)
    end

    it 'should recognize charset' do
      @mock.stub!(:content_type).and_return('Content-Type: text/html;charset=utf-8')
      curl = CurlAgent.new('http://www.example.com/')
      curl.charset.should == 'utf-8'
    end

    it 'should recognize upper case charset' do
      @mock.stub!(:content_type).and_return('Content-Type: text/html;charset=Windows-1251')
      curl = CurlAgent.new('http://www.example.com/')
      curl.charset.should == 'windows-1251'
    end

    it 'should return empty str for empty charset' do
      @mock.stub!(:content_type).and_return('Content-Type: text/html')
      @mock.should_receive(:body_str).once
      curl = CurlAgent.new('http://www.example.com/')
      curl.charset.should == ''
    end

    it 'should attempt to find charset in html' do
      @mock.stub!(:content_type).and_return('Content-Type: text/html')
      @mock.stub!(:body_str).and_return(<<EOF)
      <html>
      <head>
      <meta content="text/html; charset=ISO-8859-1" http-equiv="Content-Type"/>
      </head>
      <body></body>
      </html>
EOF
      curl = CurlAgent.new('http://www.example.com/')
      curl.charset.should == 'iso-8859-1'
    end
  end

  describe 'when used with open' do
    before(:each) do
      @headers = {'User-Agent'=>'foo'}
      @curl = mock('curl')
      @curl.stub!(:headers).and_return(@headers)
      @curl.stub!(:perform!)
      @curl.stub!(:body_str).and_return('')
      CurlAgent.should_receive(:new).and_return(@curl)
    end

    it 'shall permit to specify user-agent' do
      @curl.headers['User-Agent'].should_not == 'curl'
      CurlAgent.open('http://www.example.com/', 'User-Agent'=>'curl')
      @curl.headers['User-Agent'].should == 'curl'
    end

    it 'shall permit to override timeout' do
      @curl.should_receive(:'timeout=').once.with(10)
      CurlAgent.open('http://www.example.com/', :timeout => 10)
    end

  end
end
