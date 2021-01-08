# frozen_string_literal: true

require_relative './test_helper'

describe 'Gamesdb - developers', :vcr do
  let(:client) { Gamesdb::Client.new(ENV['GAMESDB_API_KEY']) }

  describe 'developers' do
    it 'should return the developers' do
      @developers = client.developers

      expect(@developers.count.positive?)
      expect(@developers.first.keys).must_equal(['id', 'name'])
    end
  end
end
