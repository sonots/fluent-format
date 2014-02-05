require 'thor'
require_relative '../../fluent-format'

module Fluent
  class Format
    class CLI < Thor
      default_command :format
      desc "format", "Format fluent.conf"
      option :config, :aliases => ["-c"], :type => :string, :default => 'fluent.conf', :desc => 'Fluentd configuration file'
      def format
        config = @options[:config]
        puts Fluent::Format.format(config)
      rescue => e
        $log.error "#{e.class}: #{e}"
        exit 1
      end

      desc "check", "Check fluent.conf"
      option :config, :aliases => ["-c"], :type => :string, :default => 'fluent.conf', :desc => 'Fluentd configuration file'
      option :plugin, :aliases => ["-p"], :type => :string, :desc => 'Fluentd plugin directory'
      def check
        config = @options[:config]
        plugin = @options[:plugin]
        Fluent::Format.check(config, plugin) || exit(1)
      rescue => e
        $log.error "#{e.class}: #{e}"
        exit 1
      end
    end
  end
end
