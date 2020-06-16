# frozen_string_literal: true

RSpec.describe RangeScan::Matcher do
  subject { described_class.new "test" }

  let(:results) { [{ body: "test" }, { body: "foo" }, { body: "bar" }] }

  describe "#filter" do
    it do
      expect(subject.filter(results).length).to eq(1)
    end
  end
end
