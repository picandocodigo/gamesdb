# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thegamesdb/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'thegamesdb'
  spec.version       = Gamesdb::VERSION
  spec.authors       = ['Fernando Briano']
  spec.email         = ['fernando@picandocodigo.net']
  spec.summary       = 'Client for TheGamesDB API (thegamesdb.net).'
  spec.description   = 'Ruby Client for TheGamesDB API (thegamesdb.net). See README.md for usage'
  spec.homepage      = 'http://github.com/picandocodigo/gamesdb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '> 2.5.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug' unless defined?(JRUBY_VERSION)
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'minitest-vcr'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr', '~> 4'
  spec.add_development_dependency 'webmock'
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/picandocodigo/gamesdb/issues',
    'changelog_uri' => 'https://github.com/picandocodigo/gamesdb/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/picandocodigo/gamesdb/blob/master/README.md#gamesdb',
    'homepage_uri' => 'https://github.com/picandocodigo/gamesdb',
    'source_code_uri' => 'https://github.com/picandocodigo/gamesdb'
  }
end
# rubocop:enable Metrics/BlockLength
