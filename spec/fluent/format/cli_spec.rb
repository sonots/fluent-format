require 'spec_helper'
require 'fluent/format/cli'

describe Fluent::Format::CLI do
  let(:cli) { Fluent::Format::CLI.new }

  def capture_stderr
    $stderr = StringIO.new
    begin
      yield
    rescue SystemExit
    end
    return $stderr.string
  ensure
    $stderr = STDERR
  end

  context "#format" do
    let(:subject) { cli.invoke(:format, [], opts) }

    context "success" do
      let(:opts) { {config: "fluent.conf"} }
      it { capture_stderr { subject }.should == "" }
      it { expect { subject }.not_to raise_error }
    end

    context "failure" do
      let(:opts) { {config: "unknown.conf"} }
      it { capture_stderr { subject }.should include "No such file or directory" }
      it { expect { subject }.to raise_error(SystemExit) }
    end
  end

  context "#check" do
    let(:subject) { cli.invoke(:check, [], opts) }

    context "success" do
      let(:opts) { {config: "fluent.conf"} }
      it { capture_stderr { subject }.should == "" }
      it { expect { subject }.not_to raise_error }
    end

    context "plugin option" do
      let(:opts) { {config: "fluent.conf", plugin: "example"} }
      it { capture_stderr { subject }.should == "" }
      it { expect { subject }.not_to raise_error }
    end

    context "require option" do
      let(:opts) { {config: "fluent.conf", require: ["example/out_example"]} }
      it { capture_stderr { subject }.should == "" }
      it { expect { subject }.not_to raise_error }
    end

    context "syntax error" do
      let(:opts) { {config: "example/syntax_error.conf"} }
      it { capture_stderr { subject }.should include("parse error") }
      it { expect { subject }.to raise_error(SystemExit) }
    end

    context "plugin error" do
      let(:opts) { {config: "example/plugin_error.conf"} }
      it { capture_stderr { subject }.should include("Unknown input plugin") }
      it { expect { subject }.to raise_error(SystemExit) }
    end

    context "param error" do
      let(:opts) { {config: "example/param_error.conf", plugin: "example"} }
      it { capture_stderr { subject }.should include("out_example.rb") }
      it { expect { subject }.to raise_error(SystemExit) }
    end
  end
end
