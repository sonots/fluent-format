# encoding: utf-8
require "bundler/setup"
require "pry"
require 'fluent-format'

ROOT = File.dirname(__FILE__)
Dir[File.expand_path("support/**/*.rb", ROOT)].each {|f| require f }
