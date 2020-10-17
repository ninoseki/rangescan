# frozen_string_literal: true

require "thor"
require "json"

module RangeScan
  class CLI < Thor
    desc "scan [IP_WITH_SUBNET_MASK, REGEXP]", "Scan an IP range & filter by a regexp (default regexp = .)"
    method_option :host, type: :string, desc: "Host header"
    method_option :port, type: :numeric, desc: "Port"
    method_option :scheme, type: :string, desc: "Scheme (http or https)"
    method_option :timeout, type: :numeric, desc: "Timeout in seconds"
    method_option :user_agent, type: :string, desc: "User Agent"
    method_option :verify_ssl, type: :boolean, desc: "Whether to verify SSL or not"
    method_option :max_concurrency, type: :numeric, desc: "Concurrency limit for HTTP requests to scan"
    method_option :headers, type: :hash, default: {}, desc: "Custom headers"
    def scan(ip_with_subnet_mask, regexp = ".")
      symbolized_options = symbolize_hash_keys(options)
      range = Range.new(ip_with_subnet_mask)

      scanner = Scanner.new(**symbolized_options)
      results = scanner.scan(range.to_a)

      matcher = Matcher.new(regexp)
      filtered = matcher.filter(results)

      puts JSON.pretty_generate(filtered)
    end

    default_command :scan

    no_commands do
      def symbolize_hash_keys(hash)
        hash.map { |k, v| [k.to_sym, v] }.to_h
      end
    end

    class << self
      def exit_on_failure?
        true
      end
    end
  end
end
