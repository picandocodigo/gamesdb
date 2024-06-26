# frozen_string_literal: true

require_relative './test_helper'

describe 'Gamesdb - client', :vcr do
  let(:client) { Gamesdb::Client.new(ENV['GAMESDB_API_KEY']) }

  describe 'client' do
    it 'should update allowances' do
      VCR.use_cassette('should update allowances') do
        client.games_by_id(1904)
        monthly = client.remaining_monthly_allowance
        client.games_by_id(1527)
        expect(client.remaining_monthly_allowance).must_equal(monthly - 1)
      end
    end

    describe 'errors' do
      let(:client) { Gamesdb::Client.new('invalid_api_key') }

      it 'should raise http error' do
        VCR.use_cassette('should raise error') do
          assert_raises Gamesdb::Error do
            client.games_by_id(1904)
          end
        end
      end
    end
  end
end
