require 'spec_helper'
require 'fluent/format/cli'

describe Fluent::Format::CLI do
  let(:cli) { Fluent::Format::CLI.new }

  context "#format" do
    let(:subject) { cli.invoke(:format, [], opts) }

    context "success" do
      let(:opts) { {config: "fluent.conf"} }
      it { expect { subject }.not_to raise_error }
    end

    context "failure" do
      let(:opts) { {config: "unknown.conf"} }
      it { expect { subject }.to raise_error(SystemExit) }
    end
  end

  context "#check" do
    let(:subject) { cli.invoke(:check, [], opts) }

    context "success" do
      let(:opts) { {config: "fluent.conf"} }
      it { expect { subject }.not_to raise_error }
    end

    context "failure" do
      let(:opts) { {config: "unknown.conf"} }
      it { expect { subject }.to raise_error(SystemExit) }
    end
  end
end
