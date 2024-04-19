# frozen_string_literal: true

require_relative './test_helper'

describe 'Gamesdb - genres', :vcr do
  let(:client) { Gamesdb::Client.new(ENV['GAMESDB_API_KEY']) }

  describe 'genres' do
    it 'should return the genres' do
      VCR.use_cassette('genres') do
        @genres = client.genres

        expect(@genres.count).must_equal 29
        expect(@genres.min_by { |g| g['id'] }).must_equal({ 'id' => 1, 'name' => 'Action' })
      end
    end
  end
end
