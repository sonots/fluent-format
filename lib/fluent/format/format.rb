module Fluent
  class Format
    class Format
      # Initialize
      #
      # @param [IO|String] config filename or IO Object
      def initialize(config_dev, opts = {})
        @config_dev = config_dev
        @use_v1_config = opts[:use_v1_config]
      end

      # Format config
      #
      # @raise Fluent::ConfigParseError if conf has syntax errors
      # @raise Fluent::ConfigError      if plugin raises config error
      # @return [String] the formatted config
      def run
        formatted = read(@config_dev, @use_v1_config)
        indent(formatted)
      end

      # Read config (this does formatting)
      #
      # @param [IO|String] config_dev config filename or IO Object
      # @raise Fluent::ConfigParseError if conf has syntax errors
      # @raise Fluent::ConfigError      if plugin raises config error
      # @return [String] the formatted config
      def read(config_dev, use_v1_config)
        if config_dev.respond_to?(:read) # IO object
          str = config_dev.read
          fname = '-'
          basename = '-'
        else
          str = File.read(config_dev)
          fname = File.basename(config_dev)
          basename = File.dirname(config_dev)
        end
        Fluent::Config.parse(str, fname, basename, use_v1_config)
      end

      private

      # hmm, ugly workaround
      def indent(conf)
        lines = conf.to_s.split("\n")[1..-2] # remove <ROOT> and </ROOT>
        lines = lines.map {|line| line[2..-1] } # remove heading 2 white spaces
        lines.join("\n")
      end
    end
  end
end
