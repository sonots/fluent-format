require 'fluent/supervisor'

module Fluent
  class Format
    class Check
      # Initialize
      #
      # @param [IO|String] config_dev
      # @param [String] plugin_dir the plugin directory
      # @param [Array] libs load libraries (to require)
      def initialize(config_dev, plugin_dir = nil, libs = nil)
        @opts = {
          :config_path => config_dev, # Fluent::DEFAULT_CONFIG_PATH,
          :plugin_dirs => [Fluent::DEFAULT_PLUGIN_DIR],
          :log_level => Fluent::Log::LEVEL_INFO,
          :log_path => nil,
          :daemonize => false,
          :libs => [],
          :setup_path => nil,
          :chuser => nil,
          :chgroup => nil,
          :suppress_interval => 0,
          :suppress_repeated_stacktrace => false,
        }
        @opts[:plugin_dirs] << plugin_dir if plugin_dir
        @opts[:libs] += libs if libs and !libs.empty?
      end

      # Check config file
      #
      # @raise Fluent::ConfigParseError if conf has syntax errors
      # @raise Fluent::ConfigError      if plugin raises config error
      # @return true if success
      def run
        Fluent::Supervisor.new(@opts).extended_dry_run
      end
    end
  end
end

# lib/fluent/supervisor.rb
# Open the existing class and define new methods
module Fluent
  class Supervisor
    # Extended to accept IO object
    #
    # @raise Fluent::ConfigParseError if conf has syntax errors
    # @raise Fluent::ConfigError      if plugin raises config error
    # @return true if success
    def extended_dry_run
      extended_read_config
      change_privilege
      init_engine
      install_main_process_signal_handlers
      run_configure
      true
    end

    # Extended to accept IO object
    def extended_read_config
      if @config_path.respond_to?(:read) # IO object
        @config_data = @config_path.read
      else
        @config_fname = File.basename(@config_path)
        @config_basedir = File.dirname(@config_path)
        @config_data = File.read(@config_path)
      end
      if @inline_config == '-'
        @config_data << "\n" << STDIN.read
      elsif @inline_config
        @config_data << "\n" << @inline_config.gsub("\\n","\n")
      end
    end
  end
end
