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
      it { expect(capture_stderr { subject }).to eq "" }
      it { expect { subject }.not_to raise_error }
    end

    context "failure" do
      let(:opts) { {config: "unknown.conf"} }
      it { expect(capture_stderr { subject }).to include "No such file or directory" }
      it { expect { subject }.to raise_error(SystemExit) }
    end
  end

  context "#check" do
    let(:subject) { cli.invoke(:check, [], opts) }

    context "success" do
      let(:opts) { {config: "fluent.conf"} }
      it { expect(capture_stderr { subject }).to eq "" }
      it { expect { subject }.not_to raise_error }
    end

    context "-p option" do
      let(:opts) { {config: "fluent.conf", plugin_dirs: ["example"]} }
      it { expect(capture_stderr { subject }).to eq "" }
      it { expect { subject }.not_to raise_error }
    end

    context "-r option" do
      let(:libs) { [File.expand_path('../../../example/out_example', File.dirname(__FILE__))] }
      let(:opts) { {config: "fluent.conf", libs: libs } }
      it { expect(capture_stderr { subject }).to eq "" }
      it { expect { subject }.not_to raise_error }
    end

    context "syntax error" do
      let(:opts) { {config: "example/syntax_error.conf"} }
      it { expect(capture_stderr { subject }).to include("parse error") }
      it { expect { subject }.to raise_error(SystemExit) }
    end

    context "plugin error" do
      let(:opts) { {config: "example/plugin_error.conf"} }
      it { expect(capture_stderr { subject }).to include("Unknown input plugin") }
      it { expect { subject }.to raise_error(SystemExit) }
    end

    context "param error" do
      let(:opts) { {config: "example/param_error.conf", plugin_dirs: ["example"]} }
      it { expect(capture_stderr { subject }).to include("out_example.rb") }
      it { expect { subject }.to raise_error(SystemExit) }
    end
  end
end
