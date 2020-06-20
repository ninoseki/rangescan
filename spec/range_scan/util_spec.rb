# frozen_string_literal: true

RSpec.describe RangeScan::Utils do
  subject { described_class }

  describe ".to_utf8" do
    it do
      expect(subject.to_utf8("foo")).to eq("foo")
    end

    it do
      expect(subject.to_utf8({ a: 1 })).to eq({ a: 1 })
    end

    it do
      expect(subject.to_utf8({ a: 1, b: "foo" })).to eq({ a: 1, b: "foo" })
    end
  end
end
