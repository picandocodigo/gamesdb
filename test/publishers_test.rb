# frozen_string_literal: true

require_relative './test_helper'

describe 'GamesDB - Publishers', :vcr do
  let(:client) { Gamesdb::Client.new(ENV['GAMESDB_API_KEY']) }

  describe 'publishers' do
    it 'should return publishers' do
      publishers = client.publishers

      expect(publishers.count).must_equal 4371
      expect(publishers.first.keys).must_equal(['id', 'name'])
    end
  end
end
