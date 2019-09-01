require 'thegamesdb/version'
require 'thegamesdb/config'
require 'net/http'
require 'json'

# Client for TheGamesDB API (thegamesdb.net)
module Gamesdb
  BASE_URL = 'https://api.thegamesdb.net/'.freeze
  IMAGES_BASE_URL = 'https://legacy.thegamesdb.net/banners/'.freeze

  # Method for listing platform's games
  # http://wiki.thegamesdb.net/index.php?title=GetPlatformGames
  #
  # Parameters: platform id (int) || platform slug (string)
  # For information on how to attain a valid platform slug see `platform`
  #
  # == Returns:
  # Array of Hashes with games info
  def self.platform_games(platform)
    url = platform.is_a?(Numeric) ? 'GetPlatformGames.php' : 'PlatformGames.php'
    data = xml_response(url, platform: platform)
    process_platform_games(data)
  end

  # Method for listing platforms
  # http://wiki.thegamesdb.net/index.php?title=GetPlatformsList
  #
  # Parameters: none
  #
  # == Returns:
  # Array of Hashes with platforms info
  #
  def self.platforms
    url = 'GetPlatformsList.php'
    data = xml_response(url)
    platforms = []

    data[:Platforms].first.last.each do |platform|
      platforms << { name: platform[:name], id: platform[:id].to_i, slug: platform[:alias] }
    end
    platforms
  end

  # This API feature returns a set of metadata and artwork data for a
  # specified Platform ID.
  # http://wiki.thegamesdb.net/index.php/GetPlatform
  #
  # Parameters:
  #  - id - (int) The numeric ID of the platform in the GamesDB database
  #
  # == Returns:
  # Hash with platform info
  #
  def self.platform(id)
    url = 'GetPlatform.php'
    data = xml_response(url, id: id)[:Platform]
    data[:name] = data.delete(:Platform)
    data
  end

  # Method for getting game info
  # TODO: name and platform parameters (for search)
  # http://wiki.thegamesdb.net/index.php?title=GetGame
  #
  # Parameters:
  #  - id - (int) Game id
  #
  # == Returns:
  # Hash with game info
  #
  def self.game(id)
    url = 'Games/ByGameID'
    params = {
      id: id,
      fields: 'players,publishers,genres,overview,last_updated,rating,platform,coop,youtube,os,processor,ram,hdd,video,sound,alternates',
      include: 'boxart,platform'
    }
    data = json_response(url, params)
    symbolize_keys(data['games'].first)
  end

  # The GetGamesList API search returns a listing of games matched up
  # with loose search terms.
  # http://wiki.thegamesdb.net/index.php/GetGamesList
  #
  # Parameters:
  # - name (required)
  # - TODO: platform (optional): filters results by platform (not implemented)
  # - TODO: genre (optional): filters results by genre (not
  # implemented)
  #
  # == Returns:
  # Hash with game info:  id, name (not-unique), release_date,
  # platform
  #
  def self.games_list(name)
    url = 'Games/ByGameName'
    data = json_response(url, name: name)
    data['games'].map { |game| symbolize_keys(game) }
  end

  # This API feature returns a list of available artwork types and
  # locations specific to the requested game id in the database. It
  # also lists the resolution of any images available. Scrapers can be
  # set to use a minimum or maximum resolution for specific images
  # http://wiki.thegamesdb.net/index.php/GetArt
  #
  # Parameters
  # - id - (integer) The numeric ID of the game in Gamesdb that you
  # like to fetch artwork details for
  #
  # == Returns:
  # Hash with game art info: fanart (array), boxart (Hash, :front,
  # :back),  screenshots (array), fanart (array)
  #
  def self.art(id)
    url = 'Games/Images'
    data = json_response(url, games_id: id)
    response = {}

    response[:base_url] = data['base_url']['original']
    response[:logo] = process_logo(data, id)
    response[:boxart] = process_covers(data, id)
    response[:screenshot] = process_screenshots(data, id)
    response[:fanart] = process_fanart(data, id)
    response
  end

  def self.process_logo(data, id)
    return [] if data['images'].empty?
    logo = data['images'][id].select { |a| a['type'] == "clearlogo" }
    logo.empty? ? '' : logo.first['filename']
  end

  def self.process_fanart(data, id)
    return [] if data['images'].empty?
    fanarts = []
    fanart = data['images'][id].select do |a|
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
    return [] if data['images'].empty?
    data['images'][id].select do |a|
      a['type'] == 'screenshot'
    end.map { |b| symbolize_keys(b) }
  end

  def self.process_covers(data, id)
    return [] if data['images'].empty?
    covers = {}
    boxart = data['images'][id].select do |a|
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
    # TODO: I think this is not necessary:
    symbolize_keys(covers)
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
    response['data']
  end

  # Process games for platform_games
  def self.process_platform_games(data)
    games = []

    data['games'].each do |elem|
      name = elem['game_title']
      id = elem['id']
      date = elem['release_date']
      developers = elem['developers']
      games << { name: name, id: id, release_date: date, developers: developers }
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

  # Method for processing the fan art and screenshots into a uniform
  # collection with url, width, height and thumb url
  def self.images_from_nodes(data)
    images = []
    data.each do |art|
      images << {
        url: art.original.nodes[0],
        width: art.nodes.first.attributes[:width],
        height: art.nodes.first.attributes[:height],
        thumb: art.thumb.text
      }
    end
    images
  end

  def self.symbolize_keys(hash)
    hash.keys.each do |key|
      hash[key.to_sym] = hash.delete(key)
    end
    hash
  end
end
