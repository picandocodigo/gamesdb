# frozen_string_literal: true

require 'thegamesdb/version'
require 'thegamesdb/developers'
require 'thegamesdb/games'
require 'thegamesdb/genres'
require 'thegamesdb/platforms'
require 'thegamesdb/publishers'
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
      refresh_allowances(response)
      response
    rescue StandardError => e
      # TODO: Handle errors
      raise e
    end

    private

    def refresh_allowances(response)
      @remaining_monthly_allowance = response['remaining_monthly_allowance']
      @extra_allowance = response['extra_allowance']
      @allowance_refresh_timer = response['allowance_refresh_timer']
    end

    def process_logo(data, id)
      logo = data['images'][id.to_s].select { |a| a['type'] == 'clearlogo' }
      logo.empty? ? '' : logo.first['filename']
    end

    def process_fanart(data, id)
      fanart = select_images(data, id, 'fanart')
      return [] if fanart.empty?

      fanart.map { |art| build_individual_fanart(art) }
    end

    def process_covers(data, id)
      covers = {}
      boxart = select_images(data, id, 'boxart')
      return [] if boxart.empty?

      boxart.each do |art|
        width, height = art['resolution'].split('x') unless art['resolution'].nil?
        covers[art['side'].to_sym] = art_structure(art, width, height)
      end
      covers
    end

    def build_individual_fanart(art)
      width, height = art['resolution'].split('x') unless art['resolution'].nil?
      art_structure(art, width, height)
    end

    def art_structure(art, width, height)
      {
        url: art['filename'],
        resolution: art['resolution'],
        width: width,
        height: height
      }
    end

    def process_screenshots(data, id)
      select_images(data, id, 'screenshot').map { |b| symbolize_keys(b) }
    end

    def select_images(data, id, image_type)
      data['images'][id.to_s].select do |a|
        a['type'] == image_type
      end
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

    def symbolize_keys(hash)
      new_hash = {}
      hash.each_key do |key|
        new_hash[key.to_sym] = hash.delete(key)
      end
      new_hash
    end
  end
end
