require 'fluent/load'

module Fluent
  class Format
    class << self
      def format_config(dev)
        config =
          if dev.respond_to?(:read) # IO object
            parse_config(dev, '-', '-')
          else
            read_config(dev)
          end
        indent_config(config)
      end

    private

      # partial copy from lib/fluent/config.rb
      def read_config(path)
        File.open(path) {|io|
          parse_config(io, File.basename(path), File.dirname(path))
        }
      end

      # partial copy from lib/fluent/config.rb
      def parse_config(io, fname, basepath=Dir.pwd)
        if fname =~ /\.rb$/
          Fluent::Config::DSL::Parser.parse(io, File.join(basepath, fname))
        else
          Fluent::Config.parse(io, fname, basepath)
        end
      end

      # hmm, ugly workaround
      def indent_config(conf)
        lines = conf.to_s.split("\n")[1..-2] # remove <ROOT> and </ROOT>
        lines = lines.map {|line| line[2..-1] } # remove heading 2 white spaces
        lines.join("\n")
      end
    end
  end
end
