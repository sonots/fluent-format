# fluent-format

A command line utility to format fluentd configuration beautifully

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-format'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-format

## Command Line Interface

Format fluent.conf

    $ fluent-format -c fluent.conf

Check fluent.conf

    $ fluent-format check -c fluent.conf -p plugin_dir
    $ echo $? # 0: success 1: failure

## As a library

```ruby
require 'fluent-format'

File.open(path) {|config|
  puts Fluent::Format.format(config) # formatted string
  Fluent::Format.check(config, plugin_dir) #=> Fluent::ConfigParseError or Fluent::ConfigError if failed
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licenses

See [LICENSE](LICENSE)

