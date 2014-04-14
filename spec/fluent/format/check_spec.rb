require 'spec_helper'

describe Fluent::Format::Check do
  let(:opts) {{
    :plugin_dirs => [File.expand_path('../../../example', File.dirname(__FILE__))],
    :libs => [File.expand_path('../../../example/out_example', File.dirname(__FILE__))] 
  }}
  let(:subject) { Fluent::Format.check(config, opts) }

  context "valid" do
    let(:config) { StringIO.new(%[<match>\ntype stdout\n</match>]) }
    it { should be_true }
  end

  context "plugin option" do
    let(:config) { StringIO.new(%[<match>\ntype example\n</match>]) }
    it { should be_true }
  end

  context "syntax error" do
    let(:config) { StringIO.new(%[<source>\ntype stdout\n</match>]) }
    it { expect { subject }.to raise_error(Fluent::ConfigParseError) }
  end

  context "plugin error" do
    let(:config) { StringIO.new(%[<match>\ntype foobar\n</match>]) }
    it { expect { subject }.to raise_error(Fluent::ConfigError) }
  end

  context "param error" do
    let(:config) { StringIO.new(%[<match>\ntype example\nparam bad\n</match>]) }
    it { expect { subject }.to raise_error(Fluent::ConfigError) }
  end

  context "file_path should `include`" do
    let(:config) { File.expand_path('../../../example/include_error.conf', File.dirname(__FILE__)) }
    it { expect { subject }.to raise_error(Fluent::ConfigError) }
  end
end

