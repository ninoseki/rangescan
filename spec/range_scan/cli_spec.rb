# frozen_string_literal: true

RSpec.describe RangeScan::CLI do
  subject { described_class }

  let(:scanner) { instance_double("Scanner") }
  let(:data) { [{ body: "foo" }] }

  before { allow(scanner).to receive(:scan).and_return(data) }

  describe "#scan" do
    before { allow(RangeScan::Scanner).to receive(:new).and_return(scanner) }

    it do
      expect { subject.start ["scan", "127.0.0.1/24", "foo"] }.to output(JSON.pretty_generate(data) + "\n").to_stdout
    end

    it do
      expect { subject.start ["scan", "127.0.0.1/24"] }.to output(JSON.pretty_generate(data) + "\n").to_stdout
    end

    it do
      expect { subject.start ["scan", "127.0.0.1/24", "bar"] }.to output("[\n\n]\n").to_stdout
    end
  end
end
