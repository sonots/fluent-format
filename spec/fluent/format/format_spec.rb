require 'spec_helper'

describe Fluent::Format::Format do
  let(:subject) { Fluent::Format.format(config) }

  context "valid" do
    let(:config) { StringIO.new(%[<match>\ntype stdout\n</match>]) }
    it { should == %[<match>\n  type stdout\n</match>] }
  end

  context "syntax error" do
    let(:config) { StringIO.new(%[<source>\ntype stdout\n</match>]) }
    it { expect { subject }.to raise_error(Fluent::ConfigParseError) }
  end

  context "plugin error is not checked" do
    let(:config) { StringIO.new(%[<match>\ntype foobar\n</match>]) }
    it { should == %[<match>\n  type foobar\n</match>] }
  end

  context "file_path should `include`" do
    let(:config)   { File.expand_path('../../../example/include.conf', File.dirname(__FILE__)) }
    let(:included) { File.expand_path('../../../example/included.conf', File.dirname(__FILE__)) }
    it { should include(File.read(included)) }
  end
end


