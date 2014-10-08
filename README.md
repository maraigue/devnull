devnull
====================

Ruby implementation of null file (like /dev/null on Un*x, NUL on Windows)

DESCRIPTION
--------------------

DevNull behaves a null file, and works like an IO object. For example:

    dn = DevNull.new
    dn.puts "foo" # => nil (do nothing)
    dn.gets # => nil
    dn.read # => ""

The library may be a good solution if you would like to switch whether an input/output file is needed. For example:

    def some_process(arg, logfile = nil)
      # You may set an IO object as 'logfile'.
      # If so, logs are written to the file.
      
      result = process1(arg)
      logfile.puts result if logfile
      
      result = process2(arg)
      logfile.puts result if logfile
      
      result = process3(arg)
      logfile.puts result if logfile
    end

can be rewritten as follows:

    def some_process(arg, logfile = DevNull.new)
      logfile.puts process1(arg)
      logfile.puts process2(arg)
      logfile.puts process3(arg)
    end

INSTALLATION
--------------------

Installed by RubyGems with the command (recommended):

    $ gem install devnull

Or you can use it with downloading devnull.rb file and load it by `require "./devnull"`.

For Developers
--------------------

(auto-generation by [Hoe](https://rubygems.org/gems/hoe))

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs, and generate the RDoc.

LICENSE
--------------------

(The MIT License)

Copyright (c) 2011 H.Hiro (Maraigue)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
