require 'thor'
require_relative '../../fluent-format'

module Fluent
  class Format
    class CLI < Thor
      default_command :start
      desc "start", "Start fluent-format"
      option :config, :aliases => ["-c"], :type => :string, :default => 'fluent.conf', :desc => 'Fluentd configuration file'
      def start
        config = @options[:config]
        $log = Fluent::Log.new(STDERR, Fluent::Log::LEVEL_WARN)
        puts Fluent::Format.format_config(config)
      rescue => e
        $log.error "#{e.class}: #{e}"
        exit 1
      end
    end
  end
end
