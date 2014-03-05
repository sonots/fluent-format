# fluent-format  [![Build Status](https://travis-ci.org/sonots/fluent-format.png?branch=master)](https://travis-ci.org/sonots/fluent-format)

An utility to format or check fluentd configuration

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-format'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-format

## Command Line Interface

### Format

    $ fluent-format format -c fluent.conf
    or
    $ fluent-format -c fluent.conf

Input Example:

```
<source>
     type forward
</source>

   <match test>
    type stdout
</match>
```

Output Example:

```
<source>
  type forward
</source>
<match test>
  type stdout
</match>
```

### Check

    $ fluent-format check -c fluent.conf -p plugin_dir
    $ echo $? # 0 or 1

This returns the status code 0 if check passed,
and status code 1 with error messages if check failed. 

## As a library

### Format

```ruby
require 'fluent-format'

File.open(path) {|config|
  puts Fluent::Format.format(config)
}
```

or

```ruby
require 'fluent-format'

puts Fluent::Format.format(path)
```

Use the 2nd way when you want to exapnd `include` directive.

### Check

```ruby
require 'fluent-format'

File.open(path) {|config|
  Fluent::Format.check(config, plugin_dir)
  #=> Fluent::ConfigParseError or Fluent::ConfigError if failed
}
```

or

```ruby
require 'fluent-format'

Fluent::Format.check(path, plugin_dir)
#=> Fluent::ConfigParseError or Fluent::ConfigError if failed
```

Use the 2nd way when you want to exapnd `include` directive.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licenses

See [LICENSE](LICENSE)
