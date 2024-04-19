# frozen_string_literal: true
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/spec'
require 'vcr'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'thegamesdb'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
