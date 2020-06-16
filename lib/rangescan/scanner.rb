# frozen_string_literal: true

require "http"
require "parallel"

module RangeScan
  class Scanner
    attr_reader :context
    attr_reader :host
    attr_reader :port
    attr_reader :scheme
    attr_reader :ssl_context
    attr_reader :timeout
    attr_reader :user_agent

    def initialize(host: nil, port: nil, scheme: "http", verify_ssl: true, timeout: 5, user_agent: nil)
      @host = host
      @port = port || (scheme == "http" ? 80 : 443)
      @timeout = timeout
      @scheme = scheme
      @user_agent = user_agent

      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE unless verify_ssl
    end

    def url_for(ipv4)
      return "#{scheme}://#{ipv4}" if (port == 80 && scheme == "http") || (port == 443 && scheme == "https")

      "#{scheme}://#{ipv4}:#{port}"
    end

    def scan(ipv4s)
      Parallel.map(ipv4s) do |ipv4|
        get ipv4
      end.compact
    end

    private

    def default_headers
      { host: host, user_agent: user_agent }.compact
    end

    def ssl_options
      scheme == "http" ? {} : { ssl_context: ssl_context }
    end

    def get(ipv4)
      url = url_for(ipv4)

      begin
        res = HTTP.timeout(timeout).headers(default_headers).get(url, ssl_options)
        {
          url: url,
          ipv4: ipv4,
          code: res.code,
          headers: res.headers.to_h,
          body: res.body.to_s
        }
      rescue OpenSSL::SSL::SSLError, HTTP::Error, Addressable::URI::InvalidURIError
        nil
      end
    end
  end
end
