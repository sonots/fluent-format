require 'fluent/supervisor'

module Fluent
  class Format
    class Check
      # Initialize
      #
      # @param [IO|String] config_dev
      # @param [String] plugin_dir the plugin directory
      def initialize(config_dev, plugin_dir = nil)
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
      end

      # Check config file
      #
      # @return [Boolean]
      def run
        Fluent::Supervisor.new(@opts).ext_dry_run
      end
    end
  end
end

module Fluent
  class Supervisor
    # Extended to accept IO object
    def ext_dry_run
      ext_read_config
      change_privilege
      init_engine
      install_main_process_signal_handlers
      run_configure
      true
    rescue => e
      false
    end

    # Extended to accept IO object
    def ext_read_config
      if @config_path.respond_to?(:read) # IO object
        @config_data = @config_path.read
      else
        $log.info "reading config file", :path=>@config_path
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
