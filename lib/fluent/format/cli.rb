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
      option :plugin_dirs, :aliases => ["-p"], :type => :array, :desc => 'add plugin directory'
      option :libs, :aliases => ["-r"], :type => :array, :desc => 'load library'
      option :inline_config, :aliases => ["-i"], :type => :string, :desc => 'inline config which is appended to the config file on-fly'
      option :gemfile, :aliases => ["-g"], :type => :string, :desc => 'Gemfile path'
      option :gem_install_path, :aliases => ["-G"], :type => :string, :desc => 'Gem install path (default: $(dirname $gemfile)/vendor/bundle)'
      def check
        config = @options[:config]
        Fluent::Format.check(config, @options)
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
