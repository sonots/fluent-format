require 'fluent/supervisor'

module Fluent
  class Format
    class Check
      # Initialize
      #
      # @param [IO|String] config_dev
      def initialize(config_dev, opts = {})
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
        @opts[:plugin_dirs] += opts[:plugin_dirs] if opts[:plugin_dirs] and !opts[:plugin_dirs].empty?
        @opts[:libs] += opts[:libs] if opts[:libs] and !opts[:libs].empty?
        @opts[:inline_config] = opts[:inline_config]
        @opts[:gemfile] = opts[:gemfile]
        @opts[:gem_install_path] = opts[:gem_install_path]
      end

      # Check config file
      #
      # @raise Fluent::ConfigParseError if conf has syntax errors
      # @raise Fluent::ConfigError      if plugin raises config error
      # @return true if success
      def run
        Fluent::Format::BundlerInjection.new(@opts).run
        Fluent::Supervisor.new(@opts).extended_dry_run
      end
    end
  end
end

module Fluent
  class Format
    class BundlerInjection
      def initialize(opts = {})
        @opts = {
          :gemfile => opts[:gemfile],
          :gem_install_path => opts[:gem_install_path],
        }
      end

      def run
        # copy from lib/fluent/command/fluentd.rb
        if ENV['FLUENTD_DISABLE_BUNDLER_INJECTION'] != '1' && gemfile = @opts[:gemfile]
          ENV['BUNDLE_GEMFILE'] = gemfile
          if path = @opts[:gem_install_path]
            ENV['BUNDLE_PATH'] = path
          else
            ENV['BUNDLE_PATH'] = File.expand_path(File.join(File.dirname(gemfile), 'vendor/bundle'))
          end
          ENV['FLUENTD_DISABLE_BUNDLER_INJECTION'] = '1'
          bundler_injection
        end
      end

      def bundler_injection
        # basically copy from lib/fluent/command/bundler_injection.rb
        system("bundle install")
        unless $?.success?
          exit $?.exitstatus
        end

        cmdline = [
          'bundle',
          'exec',
          RbConfig.ruby,
          File.expand_path(File.join(File.dirname(__FILE__), '../../../bin/fluent-format')),
        ] + ARGV

        exec *cmdline
        exit! 127
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
