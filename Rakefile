# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: :rubocop

task :build_assets do
  version = Sensu::Plugins::Redis::VERSION

  %w[debian12 debian11 debian10].each do |platform|
    `docker build -t ruby-plugin-#{platform} -f Dockerfile.#{platform} .`
    `docker run -v "$PWD/assets:/tmp/assets" ruby-plugin-#{platform} cp /assets/sensu-plugins-redis.tar.gz /tmp/assets/sensu-plugins-redis_#{version}_#{platform}_linux_amd64.tar.gz`
    `docker rm $(docker ps -a -q --filter ancestor=ruby-plugin-#{platform})`
    `docker rmi ruby-plugin-#{platform}`
  end

  `cd assets && shasum -a 512 ./*.tar.gz > sensu-plugins-redis_#{version}_sha512-checksums.txt`
end
