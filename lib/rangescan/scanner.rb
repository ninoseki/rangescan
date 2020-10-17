# frozen_string_literal: true

require "async"
require "async/barrier"
require "async/semaphore"
require "async/http"
require "etc"

require "rangescan/monkey_patch"

module RangeScan
  class Scanner
    attr_reader :context
    attr_reader :headers
    attr_reader :host
    attr_reader :max_concurrency
    attr_reader :port
    attr_reader :processor_count
    attr_reader :scheme
    attr_reader :ssl_context
    attr_reader :timeout
    attr_reader :user_agent
    attr_reader :verify_ssl

    def initialize(
      headers: {},
      host: nil,
      max_concurrency: nil,
      port: nil,
      scheme: "http",
      timeout: 5,
      user_agent: nil,
      verify_ssl: true
    )
      @headers = headers
      @host = host
      @port = port || (scheme == "http" ? 80 : 443)
      @scheme = scheme
      @timeout = timeout
      @user_agent = user_agent
      @verify_ssl = verify_ssl

      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE unless verify_ssl

      @max_concurrency = max_concurrency || Etc.nprocessors * 2
    end

    def url_for(ipv4)
      return "#{scheme}://#{ipv4}" if (port == 80 && scheme == "http") || (port == 443 && scheme == "https")

      "#{scheme}://#{ipv4}:#{port}"
    end

    def scan(ipv4s)
      results = []
      Async do
        barrier = Async::Barrier.new
        semaphore = Async::Semaphore.new(max_concurrency, parent: barrier)

        ipv4s.each do |ipv4|
          semaphore.async do
            url = url_for(ipv4)

            endpoint = Async::HTTP::Endpoint.parse(url, ssl_context: ssl_context, timeout: timeout)
            client = Async::HTTP::Client.new(endpoint, retries: 0)
            res = client.get(endpoint.path, default_request_headers)

            headers = res.headers.fields.to_h
            body = res.read || ""

            results << {
              url: url,
              ipv4: ipv4,
              code: res.status,
              headers: Utils.to_utf8(headers),
              body: Utils.to_utf8(body)
            }
          rescue Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, EOFError, OpenSSL::SSL::SSLError, Async::TimeoutError
            next
          end
        end
        barrier.wait
      end
      results.compact
    end

    private

    def default_request_headers
      @default_request_headers ||= headers.merge({ "host" => host, "user-agent" => user_agent }.compact)
    end

    def ssl_options
      scheme == "http" ? {} : { ssl_context: ssl_context }
    end
  end
end
