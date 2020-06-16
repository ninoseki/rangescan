# frozen_string_literal: true

module RangeScan
  class Matcher
    attr_reader :regexp

    def initialize(regexp)
      @regexp = Regexp.new(regexp)
    end

    def filter(results)
      results.select do |result|
        body = result.dig(:body) || ""
        body =~ regexp
      end
    end
  end
end
