require 'thegamesdb/version'
require 'thegamesdb/config'
require 'net/http'
require 'json'

# Client for TheGamesDB API (thegamesdb.net)
module Gamesdb
  BASE_URL = 'https://api.thegamesdb.net/'.freeze
  IMAGES_BASE_URL = 'https://legacy.thegamesdb.net/banners/'.freeze

  # Method for listing platform's games
  # https://api.thegamesdb.net/#/operations/Games/GamesByPlatformID
  #
  # Parameters: platform id (int), page (int)
  #
  # == Returns:
  # Array of Hashes with games info
  #
  def self.games_by_platform_id(platform_id, page = 1)
    url = 'Games/ByPlatformID'
    params = {id: platform_id, page: page, include: 'boxart'}
    data = json_response(url, params)
    process_platform_games(data)
  end

  # Method for listing platforms
  # https://api.thegamesdb.net/#/operations/Platforms/Platforms
  #
  # Parameters: none
  #
  # == Returns:
  # Array of Hashes with platforms info
  #
  def self.platforms
    url = 'Platforms'
    params = { fields: 'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,display,overview,youtube' }
    data = json_response(url, params)

    data['data']['platforms'].map do |p|
      symbolize_keys(p.last)
    end
  end

  # This API feature returns a set of metadata and artwork data for a
  # specified Platform ID.
  # https://api.thegamesdb.net/#/operations/Platforms/PlatformsByPlatformID
  #
  # Parameters:
  #  - id - (int) The numeric ID of the platform in the GamesDB database
  #
  # == Returns:
  # Hash with platform info
  #
  def self.platform_by_id(id)
    url = 'Platforms/ByPlatformID'
    params = {
      id: id,
      fields: 'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,display,overview,youtube'
    }
    data = json_response(url, params)

    response = data['data']['platforms'].values.first
    symbolize_keys(response)
  end

  # Method for getting game info
  # TODO: name and platform parameters (for search)
  # https://api.thegamesdb.net/#/operations/Games/GamesByGameID
  #
  # Parameters:
  #  - id - (int) Game id
  #
  # == Returns:
  # Hash with game info
  #
  def self.game_by_id(id)
    url = 'Games/ByGameID'
    params = {
      id: id,
      fields: 'players,publishers,genres,overview,last_updated,rating,platform,coop,youtube,os,processor,ram,hdd,video,sound,alternates',
      include: 'boxart,platform'
    }
    data = json_response(url, params)
    return [] if data['data']['count'] == 0
    symbolize_keys(data['data']['games'].first)
  end

  # The GetGamesList API search returns a listing of games matched up
  # with loose search terms.
  # https://api.thegamesdb.net/#/operations/Games/GamesByGameName
  #
  # Parameters:
  # - name (required)
  # - platform (optional - platform id)
  #
  # == Returns:
  # Hash with game info:  id, name (not-unique), release_date,
  # platform, etc.
  #
  def self.games_by_name(name, platform: nil)
    url = 'Games/ByGameName'
    params = {
      fields: 'players,publishers,genres,overview,last_updated,rating,platform,coop,youtube,os,processor,ram,hdd,video,sound,alternates',
      include: 'boxart',
      name: name
    }
    unless platform.nil?
      params.merge!("filter[platform]" => platform)
    end

    data = json_response(url, params)
    process_platform_games(data)
  end

  # This API feature returns a list of available artwork types and
  # locations specific to the requested game id in the database. It
  # also lists the resolution of any images available. Scrapers can be
  # set to use a minimum or maximum resolution for specific images
  # https://api.thegamesdb.net/#/operations/Games/GamesImages
  #
  # Parameters
  # - id - (integer) The numeric ID of the game in Gamesdb that you
  # like to fetch artwork details for
  #
  # == Returns:
  # Hash with game art info: fanart (array), boxart (Hash, :front,
  # :back),  screenshots (array), fanart (array)
  #
  def self.game_images(id)
    url = 'Games/Images'
    data = json_response(url, games_id: id)
    return [] if data.dig('data', 'count') == (0 || nil)

    response = {}
    response[:base_url] = data['data']['base_url']['original']
    response[:logo] = process_logo(data['data'], id)
    response[:boxart] = process_covers(data['data'], id)
    response[:screenshot] = process_screenshots(data['data'], id)
    response[:fanart] = process_fanart(data['data'], id)
    response
  end

  def self.process_logo(data, id)
    logo = data['images'][id.to_s].select { |a| a['type'] == "clearlogo" }
    logo.empty? ? '' : logo.first['filename']
  end

  def self.process_fanart(data, id)
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

  def self.process_screenshots(data, id)
    data['images'][id.to_s].select do |a|
      a['type'] == 'screenshot'
    end.map { |b| symbolize_keys(b) }
  end

  def self.process_covers(data, id)
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

  private

  def self.configuration
    @configuration ||= Config.new
  end

  # Api call and xml parsing
  def self.json_response(url, params = {})
    params = params.merge({apikey: configuration.api_key})

    uri = URI(BASE_URL + url)
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP.get_response(uri)
    response = JSON.parse(request.body)
    response
  end

  # Process games for platform_games
  def self.process_platform_games(data)
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

  def self.process_game(game)
    game[:id] = game[:id].to_i
    game[:name] = game.delete(:GameTitle)
    game[:title] = game[:name]
    game[:platform] = game.delete(:Platform)
    game
  end

  def self.symbolize_keys(hash)
    hash.keys.each do |key|
      hash[key.to_sym] = hash.delete(key)
    end
    hash
  end
end
