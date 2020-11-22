require 'thegamesdb/version'
require 'thegamesdb/games'
require 'thegamesdb/platforms'
require 'net/http'
require 'json'

module Gamesdb
  # Client for TheGamesDB API (thegamesdb.net)
  class Client
    include Gamesdb::Games
    include Gamesdb::Platforms

    BASE_URL = 'https://api.thegamesdb.net/v1/'.freeze
    IMAGES_BASE_URL = 'https://legacy.thegamesdb.net/banners/'.freeze

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
      response = Net::HTTP.get_response(uri).body
      JSON.parse(response)
    rescue StandardError => e
      # TODO: Handle errors
      raise e
    end

    private

    def handle_errors(e)
      case e
      when Net::HTTPNotFound
        raise e
      end
    end

    def process_logo(data, id)
      logo = data['images'][id.to_s].select { |a| a['type'] == "clearlogo" }
      logo.empty? ? '' : logo.first['filename']
    end

    def process_fanart(data, id)
      fanarts = []
      fanart = data['images'][id.to_s].select do |a|
        a['type'] == 'fanart'
      end
      return [] if fanart.empty?
      fanart.each do |art|
        width, height = art['resolution'].split("x") unless art['resolution'].nil?
        fanarts << {
          url: art['filename'],
          resolution: art['resolution'],
          width: width,
          height: height
        }
      end
      fanarts
    end

    def process_screenshots(data, id)
      data['images'][id.to_s].select do |a|
        a['type'] == 'screenshot'
      end.map { |b| symbolize_keys(b) }
    end

    def process_covers(data, id)
      covers = {}
      boxart = data['images'][id.to_s].select do |a|
        a['type'] == "boxart"
      end
      return [] if boxart.empty?
      boxart.each do |art|
        width, height = art['resolution'].split("x") unless art['resolution'].nil?
        covers[art['side'].to_sym] = {
          url: art['filename'],
          resolution: art['resolution'],
          width: width,
          height: height
        }
      end
      covers
    end

    # Process games for platform_games
    def process_platform_games(data)
      games = []

      data['data']['games'].each do |elem|
        id = elem['id']
        games << {
          name: elem['game_title'],
          id: id,
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
          image: if boxart = data.dig('include', 'boxart', 'data', id.to_s)
          data['include']['boxart']['base_url']['original'] +
            boxart.select { |a| a['side'] == 'front' }.first['filename'] || ''
                 end
      }
    end
    games
  end

  def symbolize_keys(hash)
    hash.keys.each do |key|
      hash[key.to_sym] = hash.delete(key)
    end
    hash
  end
end
end
