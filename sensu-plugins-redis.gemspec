# frozen_string_literal: true

require_relative 'lib/sensu/plugins/redis'

Gem::Specification.new do |spec|
  spec.name = 'sensu-plugins-redis'
  spec.version = Sensu::Plugins::Redis::VERSION
  spec.authors = ['Kevyn Lebouille']
  spec.email = ['kevyn.lebouille@opsone.net']

  spec.summary = 'Sensu plugins for PostgreSQL'
  spec.homepage = 'https://github.com/opsone/sensu-plugins-redis'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/opsone/sensu-plugins-redis'
  spec.metadata['changelog_uri'] = 'https://github.com/opsone/sensu-plugins-redis/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'redis', '~> 5.0'
  spec.add_dependency 'sensu-plugin', '~> 4.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
