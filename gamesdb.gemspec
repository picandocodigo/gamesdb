# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamesdb/version'

Gem::Specification.new do |spec|
  spec.name          = 'gamesdb'
  spec.version       = Gamesdb::VERSION
  spec.authors       = ['Fernando Briano']
  spec.email         = ['fernando@picandocodigo.net']
  spec.summary       = 'Client for TheGamesDB API (thegamesdb.net).'
  spec.description   = 'Client for TheGamesDB API (thegamesdb.net).'
  spec.homepage      = 'http://github.com/picandocodigo/gamesdb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'ox', '~> 2.1'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'byebug'
end
