# frozen_string_literal: true

module RangeScan
  class Utils
    class << self
      def to_utf8(obj)
        return obj.dup.force_encoding(Encoding::UTF_8) if obj.is_a?(String)

        obj.map do |k, v|
          k = k.dup.force_encoding(Encoding::UTF_8) if k.is_a?(String)
          v = v.dup.force_encoding(Encoding::UTF_8) if v.is_a?(String)
          [k, v]
        end.to_h
      end
    end
  end
end
