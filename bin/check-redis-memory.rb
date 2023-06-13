#!/usr/bin/env ruby
# frozen_string_literal: true

require 'redis'
require 'sensu-plugin/check/cli'

class CheckRedisConnections < Sensu::Plugin::Check::CLI
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

  option :warning,
         description: 'Warning threshold number MB or % of allocated memory'.dup,
         short: '-w WARNING',
         long: '--warning WARNING',
         proc: proc(&:to_i),
         required: true

  option :critical,
         description: 'Critical threshold number MB or % of allocated memory'.dup,
         short: '-c CRITICAL',
         long: '--critical CRITICAL',
         proc: proc(&:to_i),
         required: true

  option :use_percentage,
         description: 'Use percentage instead of the absolute number',
         short: '-a',
         long: '--percentage',
         boolean: true,
         default: false

  def run
    redis = Redis.new(host: config[:host], port: config[:port], db: config[:db])
    used_memory = redis.info.fetch('used_memory').to_i.fdiv(1024 * 1024).round
    system_memory = redis.info.fetch('total_system_memory').to_i.fdiv(1024 * 1024).round
    unit = 'MB'

    if config[:use_percentage]
      used_memory = (used_memory.fdiv(system_memory) * 100).round
      unit = '%'
    end

    if used_memory >= config[:critical]
      critical "Redis running on #{config[:host]}:#{config[:port]} is above the CRITICAL limit: #{used_memory}#{unit} used / #{config[:critical]}#{unit} limit"
    elsif used_memory >= config[:warning]
      warning "Redis running on #{config[:host]}:#{config[:port]} is above the WARNING limit: #{used_memory}#{unit} used / #{config[:warning]}#{unit} limit"
    else
      ok "Redis memory usage: #{used_memory}#{unit} is below defined limits"
    end
  rescue StandardError
    critical "Could not connect to Redis server on #{config[:host]}:#{config[:port]}"
  end
end
