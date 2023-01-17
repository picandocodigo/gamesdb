# frozen_string_literal: true

require 'thegamesdb/version'
require 'thegamesdb/developers'
require 'thegamesdb/error'
require 'thegamesdb/games'
require 'thegamesdb/genres'
require 'thegamesdb/platforms'
require 'thegamesdb/publishers'
require 'thegamesdb/utils'
require 'net/http'
require 'json'

module Gamesdb
  # Client for TheGamesDB API (thegamesdb.net)
  class Client
    include Gamesdb::Developers
    include Gamesdb::Games
    include Gamesdb::Genres
    include Gamesdb::Platforms
    include Gamesdb::Publishers

    BASE_URL = 'https://api.thegamesdb.net/v1/'
    IMAGES_BASE_URL = 'https://legacy.thegamesdb.net/banners/'

    attr_reader :remaining_monthly_allowance, :extra_allowance, :allowance_refresh_timer

    def initialize(api_key)
      @api_key = api_key
    end

    # Perform request
    #
    # Used by every API endpoint, but can also be used manually.
    #
    # @param url [String] Required
    # @param params [Hash] optional
    #
    # @return [Hash] Parsed JSON response
    def perform_request(url, params = {})
      raise ArgumentError, 'You need to set the API KEY to use the GamesDB API' unless @api_key

      params = params.merge({ apikey: @api_key })
      uri = URI(BASE_URL + url)
      uri.query = URI.encode_www_form(params)
      response = JSON.parse(Net::HTTP.get_response(uri).body)
      http_error(response) if response['code'] >= 300

      refresh_allowances(response)
      response
    rescue StandardError => e
      raise e
    end

    private

    def refresh_allowances(response)
      @remaining_monthly_allowance = response['remaining_monthly_allowance']
      @extra_allowance = response['extra_allowance']
      @allowance_refresh_timer = response['allowance_refresh_timer']
    end

    # TODO: More granular errors
    def http_error(response)
      raise Gamesdb::Error.new(response['code'], response['status'])
    end

    # Process games for platform_games
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def process_platform_games(data)
      data['data']['games'].map do |elem|
        {
          name: elem['game_title'],
          id: elem['id'],
          release_date: elem['release_date'],
          platform: elem['platform'],
          developers: elem['developers'],
          players: elem['players'],
          publishers: elem['publishers'],
          genres: elem['genres'],
          overview: elem['overview'],
          last_updated: elem['last_updated'],
          rating: elem['rating'],
          coop: elem['coop'],
          youtube: elem['youtube'],
          alternates: elem['alternates'],
          image: if (boxart = data.dig('include', 'boxart', 'data', elem['id'].to_s))
                   data['include']['boxart']['base_url']['original'] +
                     boxart.select { |a| a['side'] == 'front' }.first['filename'] || ''
                 end
        }
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
