require 'spec_helper'

describe Fluent::Format::Check do
  let(:subject) { Fluent::Format.check(config) }

  context "valid" do
    let(:config) { StringIO.new(%[<match>\ntype stdout\n</match>]) }
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
end

