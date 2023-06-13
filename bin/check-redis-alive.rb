#! /usr/bin/env ruby
# frozen_string_literal: true

require 'redis'
require 'sensu-plugin/check/cli'

class CheckRedis < Sensu::Plugin::Check::CLI
  option :host,
         short: '-h HOST',
         long: '--host HOST',
         description: 'Redis Host to connect to',
         default: '127.0.0.1'

  option :port,
         short: '-p PORT',
         long: '--port PORT',
         description: 'Redis Port to connect to',
         proc: proc(&:to_i),
         default: 6379

  option :db,
         short: '-n DATABASE',
         long: '--db DATABASE',
         description: 'Redis database number to connect to',
         proc: proc(&:to_i),
         default: 0

  def run
    if Redis.new(host: config[:host], port: config[:port], db: config[:db]).ping == 'PONG'
      ok 'Redis is alive'
    else
      critical 'Redis did not respond to the ping command'
    end
  rescue StandardError
    critical "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
  end
end
