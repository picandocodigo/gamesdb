# frozen_string_literal: true

require_relative './test_helper'

describe 'Gamesdb - client', :vcr do
  let(:client) { Gamesdb::Client.new(ENV['GAMESDB_API_KEY']) }

  describe 'client' do
    it 'should update allowances' do
      client.games_by_id(1904)
      monthly = client.remaining_monthly_allowance
      client.games_by_id(1527)
      expect(client.remaining_monthly_allowance).must_equal(monthly - 1)
    end
  end
end
