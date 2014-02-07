$log = Fluent::Log.new($stderr, Fluent::Log::LEVEL_WARN)

module Fluent
  class Format
    # Format config file
    #
    # @param [IO|String] config_dev
    # @return [String] the formatted config
    def self.format(config_dev)
      Fluent::Format::Format.new(config_dev).run
    end

    # Check config file
    #
    # @param [IO|String] config_dev
    # @param [String] plugin_dir the plugin directory
    # @return [Boolean]
    def self.check(config_dev, plugin_dir = nil)
      Fluent::Format::Check.new(config_dev, plugin_dir).run
    end
  end
end
