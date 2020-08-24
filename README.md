# rangescan

[![Gem Version](https://badge.fury.io/rb/rangescan.svg)](https://badge.fury.io/rb/rangescan)
[![Build Status](https://travis-ci.com/ninoseki/rangescan.svg?branch=master)](https://travis-ci.com/ninoseki/rangescan)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/rangescan/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/rangescan?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/rangescan/badge)](https://www.codefactor.io/repository/github/ninoseki/rangescan)

A CLI tool to scan websites on a specific IP range and filter the results by a regexp.

## Installation

```bash
gem install rangescan
```

## Usage

```bash
$ rangescan
Commands:
  rangescan help [COMMAND]                      # Describe available commands or one specific command
  rangescan scan [IP_WITH_SUBNET_MASK, REGEXP]  # Scan an IP range & filter by a regexp

$ rangescan help scan
Usage:
  rangescan scan [IP_WITH_SUBNET_MASK, REGEXP]

Options:
  [--host=HOST]                      # Host header
  [--port=N]                         # Port to check (80 or 443)
  [--scheme=SCHEME]                  # Scheme to use (http or https)
  [--timeout=N]                      # Timeout in seconds
  [--user-agent=USER_AGENT]          # User Agent header
  [--verify-ssl], [--no-verify-ssl]  # Verify SSL or not

Scan an IP range & filter by a regexp
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
