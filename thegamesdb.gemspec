lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thegamesdb/version'

Gem::Specification.new do |spec|
  spec.name          = 'thegamesdb'
  spec.version       = Gamesdb::VERSION
  spec.authors       = ['Fernando Briano']
  spec.email         = ['fernando@picandocodigo.net']
  spec.summary       = 'Client for TheGamesDB API (thegamesdb.net).'
  spec.description   = 'Ruby Client for TheGamesDB API (thegamesdb.net). See README.md for usage'
  spec.homepage      = 'http://github.com/picandocodigo/gamesdb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'minitest-vcr'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr', '~> 4'
  spec.add_development_dependency 'webmock'
end
