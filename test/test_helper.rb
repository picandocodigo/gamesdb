require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/spec'
require 'vcr'
require 'minitest-vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
MinitestVcr::Spec.configure!

require 'thegamesdb'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
