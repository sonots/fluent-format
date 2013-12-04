# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift('lib') unless $LOAD_PATH.include?('lib')
require 'fluent/format/version'

Gem::Specification.new do |s|
  s.name        = "fluent-format"
  s.version     = Fluent::Format::VERSION
  s.authors     = ["Naotoshi Seo"]
  s.email       = ["sonots@gmail.com"]
  s.homepage    = "https://github.com/sonots/fluent-format"
  s.summary     = "A command line utility to format fluentd configuration beautifully"
  s.description = s.summary
  s.licenses    = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "fluentd"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
end
