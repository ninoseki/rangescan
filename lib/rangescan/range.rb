# frozen_string_literal: true

require "ipaddress"

module RangeScan
  class Range
    attr_reader :ip_with_subnet_mask

    def initialize(ip_with_subnet_mask)
      @ip_with_subnet_mask = IPAddress::IPv4.new(ip_with_subnet_mask)
    end

    def to_a
      ip_with_subnet_mask.to_a.map(&:to_s)
    end
  end
end
