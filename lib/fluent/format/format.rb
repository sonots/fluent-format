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
      # @raise Fluent::ConfigParseError if conf has syntax errors
      # @return [String] the formatted config
      def run
        config = Fluent::ExtConfig.read(@config_dev)
        indent(config)
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

# lib/fluent/config.rb
module Fluent
  module ExtConfig
    # Extended to accept IO object
    #
    # @raise Fluent::ConfigParseError if conf has syntax errors
    # @raise Fluent::ConfigError      if plugin raises config error
    # @return [String] parsed config string
    def self.read(dev)
      if dev.respond_to?(:read) # IO object
        parse(dev, '-', '-')
      else
        File.open(dev) {|io| parse(io, File.basename(dev), File.dirname(dev)) }
      end
    end

    # Extended to accept config dsl
    #
    # @raise Fluent::ConfigParseError if conf has syntax errors
    # @raise Fluent::ConfigError      if plugin raises config error
    # @return [String] parsed config string
    def self.parse(io, fname, basepath=Dir.pwd)
      if fname =~ /\.rb$/
        Fluent::Config::DSL::Parser.parse(io, File.join(basepath, fname))
      else
        Fluent::Config.parse(io, fname, basepath)
      end
    end
  end
end
