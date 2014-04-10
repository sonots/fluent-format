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
        taputs Fluent::Format.format(config)
      rescue => e
        $stderr.puts "#{e.class} #{e.message} #{e.backtrace.first}"
        exit 1
      end

      desc "check", "Check fluent.conf"
      option :config, :aliases => ["-c"], :type => :string, :default => 'fluent.conf', :desc => 'Fluentd configuration file'
      option :plugin, :aliases => ["-p"], :type => :string, :desc => 'Additional Fluentd plugin directory'
      option :require, :aliases => ["-r"], :type => :array, :desc => 'Additional Fluentd lib path'
      def check
        config = @options[:config]
        plugin = @options[:plugin]
        require 'pry'
        binding.pry
        libs   = @options[:require]
        Fluent::Format.check(config, plugin, libs)
      rescue => e
        $stderr.puts "#{e.class} #{e.message} #{e.backtrace.first}"
        exit 1
      end

      private

      def taputs(str)
        puts str
        str
      end
    end
  end
end
