# Ruby implementation of null file (like /dev/null on Un*x, NUL on Windows)
# (C) 2010- H.Hiro(Maraigue) main@hhiro.net
# 
# DevNull behaves a null file, and works like an IO object. For example:
# 
# <pre>dn = DevNull.new
# dn.puts "foo" # => nil (do nothing)
# dn.gets # => nil
# dn.read # => ""</pre>
# 
# The library may be a good solution if you would like to switch whether an input/output file is needed. For example:
# 
# <pre>def some_process(arg, logfile = nil)
#   # You may set an IO object as 'logfile', and logs are written to the file.
#   
#   result = process1(arg)
#   logfile.puts result if logfile
#   
#   result = process2(arg)
#   logfile.puts result if logfile
#   
#   result = process3(arg)
#   logfile.puts result if logfile
# end</pre>
# 
# can be rewritten as follows:
# 
# <pre>def some_process(arg, logfile = DevNull.new)
#   logfile.puts process1(arg)
#   logfile.puts process2(arg)
#   logfile.puts process3(arg)
# end</pre>

require "enumerator"

class DevNull
  def initialize
    # do nothing
  end
  
  # --
  # methods treated as being not implemented
  # ++
  def fileno; raise NotImplementedError; end
  alias :to_i :fileno
  def fsync; raise NotImplementedError; end
  def fdatasync; raise NotImplementedError; end
  def stat; raise NotImplementedError; end
  def fcntl(arg1, arg2); raise NotImplementedError; end
  def ioctl(arg1, arg2); raise NotImplementedError; end
  
  # --
  # methods that do nothing
  # ++
  def close; end
  def close_read; end
  def close_write; end
  def print(*args); end
  def printf(arg1, *other_args); end
  def puts(*args); end
  def ungetbyte(arg); end
  def ungetc(arg); end
  
  # --
  # methods that do nothing and returns something
  # ++
  def getc; nil; end
  def getbyte; nil; end
  def gets(arg1=nil, arg2=nil); nil; end
  def path; nil; end
  def pid; nil; end
  def external_encoding; nil; end
  def internal_encoding; nil; end
  
  def to_io; self; end
  def <<(obj); self; end
  def binmode; self; end
  def flush; self; end
  def reopen(arg1, arg2=nil); self; end
  def set_encoding(arg1, arg2=nil, arg3=nil); self; end
  
  def autoclose?; true; end
  def binmode?; true; end
  def closed?; true; end
  def eof; true; end
  def eof?; true; end
  def sync; true; end
  
  def close_on_exec?; false; end
  def closed_read?; false; end
  def closed_write?; false; end
  def isatty; false; end
  def tty?; false; end
  
  def lineno; 0; end
  def pos; 0; end
  def tell; 0; end
  def rewind; 0; end
  def seek(arg1, arg2=nil); 0; end
  def sysseek(arg1, arg2=nil); 0; end
  
  def readlines(arg1=nil, arg2=nil); []; end
  
  def putc(arg); arg; end
  def autoclose=(arg); arg; end
  def close_on_exec=(arg); arg; end
  def lineno=(arg); arg; end
  def pos=(arg); arg; end
  def sync=(arg); arg; end
  def truncate(arg); arg; end
  def write(arg); arg.to_s.length; end
  def syswrite(arg); arg.to_s.length; end
  def write_nonblock(arg); arg.to_s.length; end
  
  def each(*args); (block_given? ? self : [].to_enum); end
  alias :each_line :each
  alias :lines :each
  alias :each_byte :each
  alias :bytes :each
  alias :each_char :each
  alias :chars :each
  alias :each_codepoint :each
  alias :codepoints :each
  
  def sysread(arg1, arg2=nil); raise EOFError; end
  def readpartial(arg1, arg2=nil); raise EOFError; end
  def read_nonblock(arg1, arg2=nil); raise EOFError; end
  def readchar; raise EOFError; end
  def readbyte; raise EOFError; end
  def readline(arg1=nil, arg2=nil); raise EOFError; end
  
  def read(len = 0, outbuf = nil)
    if outbuf != nil
      outbuf.replace("")
      outbuf
    else
      (len.to_i == 0 ? "" : nil)
    end
  end
end
