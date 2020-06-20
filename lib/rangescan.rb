# frozen_string_literal: true

require "rangescan/version"

require "rangescan/range"
require "rangescan/utils"
require "rangescan/scanner"
require "rangescan/matcher"

require "rangescan/cli"

module RangeScan
  class Error < StandardError; end
end
