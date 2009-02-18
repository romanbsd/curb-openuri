require File.dirname(__FILE__) + '/spec_helper'

describe "CurbOpenuri" do
  describe "shall override Kernel::open" do
    ['http','https','ftp'].each do |p|
      it "shall use curl for #{p}" do
        CurlAgent.should_receive(:open).and_return('')
        open("#{p}://www.example.com/")
      end
    end

    it 'shall not use curl for other protocols' do
      CurlAgent.should_not_receive(:open)
      lambda {open('file:///dev/null')}.should raise_error(Errno::ENOENT)
    end

    it 'shall not use curl for files' do
      CurlAgent.should_not_receive(:open)
      open('/dev/null') {|f| }
    end

    it 'shall still call open where the object supports it' do
      mock = mock('openable')
      mock.stub!(:respond_to?).with(:open).and_return(true)
      mock.should_receive(:open)
      CurlAgent.should_not_receive(:open)
      open(mock)
    end
  end
end
