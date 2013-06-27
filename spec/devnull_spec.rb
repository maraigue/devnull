require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require "devnull"

describe DevNull do
  # GENERAL NOTE:
  # 
  # These test codes are based on the document:
  # http://www.ruby-doc.org/core/classes/IO.html .
  # However, the contents in the URL may be changed.
  # If needed, add and/or rewrite the test code.
  
  # NOTE 1:
  # 
  # This devnull library is not to support any internal statuses
  # stored in IO instances (e.g. instance variables).
  # For example,
  #
  # f = open("/dev/null")
  # f.lineno      # => 0
  # f.lineno = 10 
  # f.lineno      # => 10
  # 
  # but
  # 
  # g = DevNull.new
  # g.lineno      # => 0
  # g.lineno = 10 
  # g.lineno      # => 0
  # 
  # Such internal-status-related methods is defined,
  # but should always return statuses according to
  # its *initial* statuses.
  
  # NOTE 2:
  # 
  # Some of the instance methods for IO related to low-level I/O is
  # not implemented. In such case, the method returns NotImplementedError.
  # (e.g. DevNull#fileno)
  
  before(:each) do
    @null = DevNull.new
  end
  
  # ---------- specs for Enumerators:
  # Those methods should return an Enumerator that contains nothing.
  %w[
    each
    bytes each_byte
    chars each_char
    codepoints each_codepoint
  ].each do |method_name|
    it "should return an Enumerator for Devnull##{method_name}" do
      # First, check whether the method returns an Enumerator.
      enum = eval("@null.#{method_name}")
      enum.should be_instance_of(Enumerator)
      # Then, check whether the Enumerator is empty.
      lambda{ enum.each{ raise RuntimeError } }.should_not raise_error
      lambda{ eval("@null.#{method_name} { raise RuntimeError }") }.should_not raise_error
    end
  end
  
  # ---------- specs for called without any argument and returning self
  %w[
    flush to_io
  ].each do |method_name|
    it "should return self for Devnull##{method_name}" do
      eval("@null.#{method_name}").should == @null
    end
  end
  
  # ---------- specs for called without any argument and returning nil
  %w[
    close close_read close_write external_encoding internal_encoding
    getbyte getc pid
  ].each do |method_name|
    it "should return nil for Devnull##{method_name}" do
      eval("@null.#{method_name}").should == nil
    end
  end
  
  # ---------- specs for called with 1 argument and returning nil
  %w[
    ungetbyte ungetc
  ].each do |method_name|
    it "should return nil for Devnull##{method_name} with 1 arguments" do
      lambda{ eval("@null.#{method_name}") }.should raise_error(ArgumentError)
      eval("@null.#{method_name}(1)").should == nil
      lambda{ eval("@null.#{method_name}(1, 2)") }.should raise_error(ArgumentError)
    end
  end
  
  # ---------- specs for called with any number of arguments and returning nil
  %w[
    print puts
  ].each do |method_name|
    it "should return nil for Devnull##{method_name} with any number of arguments" do
      eval("@null.#{method_name}").should == nil
      eval("@null.#{method_name}(1)").should == nil
      eval("@null.#{method_name}(1, 2, 3)").should == nil
    end
  end
  
  # ---------- specs for called without any argument and returning true
  %w[
    autoclose? binmode? closed? eof eof? sync
  ].each do |method_name|
    it "should return true for Devnull##{method_name}" do
      eval("@null.#{method_name}").should be_true
    end
  end
  
  # ---------- specs for called without any argument and returning false
  %w[
    close_on_exec? isatty tty?
  ].each do |method_name|
    it "should return false for Devnull##{method_name}" do
      eval("@null.#{method_name}").should be_false
    end
  end
  
  # ---------- specs for called without any argument and returning 0
  %w[
    lineno pos tell rewind
  ].each do |method_name|
    it "should return 0 for Devnull##{method_name}" do
      eval("@null.#{method_name}").should == 0
    end
  end
  
  # ---------- specs for called with 1 or 2 arguments and returning 0
  %w[
    seek sysseek
  ].each do |method_name|
    it "should return 0 for Devnull##{method_name}" do
      lambda{ eval("@null.#{method_name}") }.should raise_error(ArgumentError)
      eval("@null.#{method_name}(1)").should == 0
      eval("@null.#{method_name}(1, 2)").should == 0
      lambda{ eval("@null.#{method_name}(1, 2, 3)") }.should raise_error(ArgumentError)
    end
  end
  
  # ---------- specs for called with a string argument and returning its string length
  %w[
    syswrite write write_nonblock
  ].each do |method_name|
    it "should return the argument string's length for Devnull##{method_name}(string)" do
      eval("@null.#{method_name}('hoge')").should == 4
      eval("@null.#{method_name}('abcdefg')").should == 7
    end
  end
  
  # ---------- specs for assignment-type methods that do nothing
  %w[
    autoclose= close_on_exec= lineno= pos= sync=
  ].each do |method_name|
    it "should do nothing when called Devnull##{method_name}" do
      lambda{ eval("@null.#{method_name}(1)") }.should_not raise_error
    end
  end
  
  # ---------- specs for methods called with no argument and always failing with EOFError
  %w[
    readbyte readchar
  ].each do |method_name|
    it "should raise EOFError when called Devnull##{method_name}" do
      lambda{ eval("@null.#{method_name}") }.should raise_error(EOFError)
      lambda{ eval("@null.#{method_name}(1)") }.should raise_error(ArgumentError)
    end
  end
  
  # ---------- specs for methods called with 1 or 2 arguments and always failing with EOFError
  %w[
    read_nonblock readpartial sysread
  ].each do |method_name|
    it "should raise EOFError when called Devnull##{method_name}" do
      lambda{ eval("@null.#{method_name}") }.should raise_error(ArgumentError)
      lambda{ eval("@null.#{method_name}(1)") }.should raise_error(EOFError)
      lambda{ eval("@null.#{method_name}(1, 2)") }.should raise_error(EOFError)
      lambda{ eval("@null.#{method_name}(1, 2, 3)") }.should raise_error(ArgumentError)
    end
  end
  
  # ---------- specs for not implemented methods
  it "should raise NotImplementedError for Devnull#fcntl when called with 2 arguments" do
    lambda{ @null.fcntl(0) }.should raise_error(ArgumentError)
    lambda{ @null.fcntl(0, 0) }.should raise_error(NotImplementedError)
    lambda{ @null.fcntl(0, 0, 0) }.should raise_error(ArgumentError)
  end
  
  it "should raise NotImplementedError for Devnull\#\{fsync,fdatasync\}" do
    lambda{ @null.fsync }.should raise_error(NotImplementedError)
    lambda{ @null.fdatasync }.should raise_error(NotImplementedError)
  end
  
  it "should raise NotImplementedError for Devnull\#\{fileno,to_i\}" do
    lambda{ @null.fileno }.should raise_error(NotImplementedError)
    lambda{ @null.to_i }.should raise_error(NotImplementedError)
  end
  
  it "should raise NotImplementedError for Devnull#ioctl when called with 2 arguments" do
    lambda{ @null.ioctl(0) }.should raise_error(ArgumentError)
    lambda{ @null.ioctl(0, 0) }.should raise_error(NotImplementedError)
    lambda{ @null.ioctl(0, 0, 0) }.should raise_error(ArgumentError)
  end
  
  it "should raise NotImplementedError for Devnull#stat" do
    lambda{ @null.stat }.should raise_error(NotImplementedError)
  end
  
  # ---------- others
  it "should return self for Devnull#<<" do
    (@null << "test").should == @null
  end
  
  it "should do nothing for Devnull#binmode" do
    lambda{ @null.binmode }.should_not raise_error
  end
  
  it "should return nil for Devnull#printf when called with 1 or more arguments" do
    lambda{ @null.printf }.should raise_error(ArgumentError)
    @null.printf(0).should be_nil
    @null.printf(0, 0).should be_nil
    @null.printf(0, 0, 0, 0).should be_nil
  end
  
  it "should return the argument for Devnull#putc when called with 1 arguments" do
    lambda{ @null.putc }.should raise_error(ArgumentError)
    @null.putc(0).should == 0
    @null.putc("hoge").should == "hoge"
    lambda{ @null.putc(0, 0)  }.should raise_error(ArgumentError)
  end
  
  it "should return an empty string for Devnull#read() or Devnull#read(0)" do
    @null.read.should == ""
    @null.read(0).should == ""
    
    buffer = "hoge"
    @null.read(0, buffer).should be_equal(buffer)
    buffer.should == ""
  end
  
  it "should return nil for Devnull#read(positive_integer)" do
    @null.read(1).should be_nil
    @null.read(10).should be_nil
    
    buffer = "hoge"
    @null.read(10, buffer).should be_equal(buffer)
    buffer.should == ""
  end
  
  it "should return nil for Devnull#gets(0 to 2 arguments)" do
    @null.gets().should == nil
    @null.gets(0).should == nil
    @null.gets(0, 0).should == nil
    lambda{ @null.gets(0, 0, 0) }.should raise_error(ArgumentError)
  end
  
  it "should raise EOFError when called Devnull#readline" do
    lambda{ @null.readline }.should raise_error(EOFError)
    lambda{ @null.readline(0) }.should raise_error(EOFError)
    lambda{ @null.readline(0, 0) }.should raise_error(EOFError)
    lambda{ @null.readline(0, 0, 0) }.should raise_error(ArgumentError)
  end
  
  it "should return empty array for Devnull#readlines(0 to 2 arguments)" do
    @null.readlines().should == []
    @null.readlines(0).should == []
    @null.readlines(0, 0).should == []
    lambda{ @null.readlines(0, 0, 0) }.should raise_error(ArgumentError)
  end
  
  it "should return self for Devnull#reopen(1 or 2 arguments)" do
    lambda{ @null.reopen() }.should raise_error(ArgumentError)
    @null.reopen(0).should == @null
    @null.reopen(0, 0).should == @null
    lambda{ @null.reopen(0, 0, 0) }.should raise_error(ArgumentError)
  end
  
  it "should return self for Devnull#set_encoding(1 to 3 arguments)" do
    lambda{ @null.set_encoding() }.should raise_error(ArgumentError)
    @null.set_encoding(0).should == @null
    @null.set_encoding(0, 0).should == @null
    @null.set_encoding(0, 0, 0).should == @null
    lambda{ @null.set_encoding(0, 0, 0, 0) }.should raise_error(ArgumentError)
  end
end
