# frozen_string_literal: true

RSpec.describe RangeScan::Range do
  subject { described_class.new "172.16.10.1/24" }

  describe "#to_a" do
    it do
      expect(subject.to_a.length).to eq(256)
    end
  end
end
