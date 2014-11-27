$log = Fluent::Log.new($stderr, Fluent::Log::LEVEL_WARN)

module Fluent
  class Format
    # Format config file
    #
    # @param [IO|String] config_dev
    # @param [Hash] opts
    # @return [String] the formatted config
    def self.format(config_dev, opts = {})
      Fluent::Format::Format.new(config_dev, opts).run
    end

    # Check config file
    #
    # @param [IO|String] config_dev
    # @param [Hash] opts
    # @return [Boolean]
    def self.check(config_dev, opts = {})
      Fluent::Format::Check.new(config_dev, opts).run
    end
  end
end
