# devnull

Rubygems website :: https://rubygems.org/gems/devnull

Source code / Documentation :: https://github.com/maraigue/devnull

## Description

Ruby implementation of null file (like /dev/null on Un*x, NUL on Windows)

## Note

You can do the similar with a built-in constant [File::NULL](https://docs.ruby-lang.org/ja/latest/method/File=3a=3aConstants/c/NULL.html): the object `open(File::NULL, "rw")` behaves almost the same as the object `DevNull.new`.

After the library is developed ([at Ruby 1.9.3](https://svn.ruby-lang.org/repos/ruby/tags/v1_9_3_0/NEWS)), Ruby introduced the built-in constant `File::NULL` that represents the *name* of the (environment-dependent) null file.  
Notice that, different from `open(File::NULL, "rw")`, `DevNull.new` does *not* use file-opening API.

## Synopsis

DevNull instance works like an IO object. For example:

```ruby
dn = DevNull.new
dn.puts "foo" # => nil (do nothing)
dn.gets # => nil
dn.read # => ""
```

The library may be a good solution if you would like to switch whether an input/output file is needed. For example:

```ruby
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
```

can be rewritten as follows:

```ruby
def some_process(arg, logfile = DevNull.new)
  logfile.puts process1(arg)
  logfile.puts process2(arg)
  logfile.puts process3(arg)
end
```

## Installation

Installed by RubyGems with the command (recommended):

  $ gem install devnull

Or you can use it with downloading devnull.rb file and load it by `require "./devnull"`.

## Developers

(auto-generation by Hoe https://rubygems.org/gems/hoe)

After checking out the source, run:

```sh
$ rake newb
```

This task will install any missing dependencies, run the tests/specs, and generate the RDoc.

## License

(The MIT License)

Copyright (c) 2011- H.Hiro (Maraigue)

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
