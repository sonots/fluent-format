module Fluent
  class Format
    class Format
      # Initialize
      #
      # @param [IO|String] config_dev
      def initialize(config_dev)
        @config_dev = config_dev
      end

      # Format config
      #
      # @return [String] the formatted config
      def run
        config = read_config(@config_dev)
        indent_config(config)
      end

      private

      # partial copy from lib/fluent/config.rb
      def read_config(dev)
        if dev.respond_to?(:read) # IO object
          parse_config(dev, '-', '-')
        else
          File.open(dev) {|io| parse_config(io, File.basename(dev), File.dirname(dev)) }
        end
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
