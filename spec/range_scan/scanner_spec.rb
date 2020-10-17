# frozen_string_literal: true

require "glint"
require "webrick"
require "etc"

HOST = "127.0.0.1"

def server
  server = Glint::Server.new do |port|
    http = WEBrick::HTTPServer.new(
      BindAddress: HOST,
      Port: port,
      Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
      AccessLog: []
    )

    http.mount_proc("/") do |_, res|
      body = "foo"

      res.status = 200
      res.content_length = body.size
      res.content_type = "text/plain"
      res.body = body
    end

    trap(:INT) { http.shutdown }
    trap(:TERM) { http.shutdown }

    http.start
  end

  Glint::Server.info[:http_server] = {
    host: HOST,
    port: server.port
  }
  server
end

RSpec.describe RangeScan::Scanner do
  before(:all) do
    @server = server
    @server.start
  end

  after(:all) { @server.stop }

  let(:host) { HOST }
  let(:port) { @server.port }

  describe "#timeout" do
    it do
      scanner = described_class.new(timeout: 10)
      expect(scanner.timeout).to eq(10)
    end

    it do
      scanner = described_class.new
      expect(scanner.timeout).to eq(5)
    end
  end

  describe "#port" do
    it do
      scanner = described_class.new(scheme: "http")
      expect(scanner.port).to eq(80)
    end

    it do
      scanner = described_class.new(scheme: "https")
      expect(scanner.port).to eq(443)
    end

    it do
      scanner = described_class.new
      expect(scanner.port).to eq(80)
    end
  end

  describe "#max_concurrency" do
    it do
      scanner = described_class.new(scheme: "http")
      expect(scanner.max_concurrency).to eq(Etc.nprocessors * 8)
    end

    it do
      scanner = described_class.new(scheme: "https", max_concurrency: 3)
      expect(scanner.max_concurrency).to eq(3)
    end
  end

  describe "#url_for" do
    it do
      scanner = described_class.new
      url = scanner.url_for("127.0.0.1")
      expect(url).to eq("http://127.0.0.1")
    end

    it do
      scanner = described_class.new(port: 81)
      url = scanner.url_for("127.0.0.1")
      expect(url).to eq("http://127.0.0.1:81")
    end

    it do
      scanner = described_class.new(scheme: "https")
      url = scanner.url_for("127.0.0.1")
      expect(url).to eq("https://127.0.0.1")
    end

    it do
      scanner = described_class.new(scheme: "https", port: 81)
      url = scanner.url_for("127.0.0.1")
      expect(url).to eq("https://127.0.0.1:81")
    end
  end

  describe "#scan" do
    it do
      scanner = described_class.new(port: port)
      results = scanner.scan([host])
      expect(results.length).to eq(1)
    end

    it do
      scanner = described_class.new(port: port)
      results = scanner.scan([host])
      expect(results.first.dig(:body)).to eq("foo")
    end

    it do
      scanner = described_class.new(port: port)
      results = scanner.scan([host])

      first = results.first
      [:url, :ipv4, :code, :headers, :body].all? { |key| first.key? key }
    end
  end
end
