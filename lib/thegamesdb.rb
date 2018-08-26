require 'thegamesdb/version'
require 'ox'
require 'net/http'

# Client for TheGamesDB API (thegamesdb.net)
module Gamesdb
  BASE_URL = 'http://legacy.thegamesdb.net/api/'
  IMAGES_BASE_URL = 'http://legacy.thegamesdb.net/banners/'

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
    url = 'GetGame.php'
    data = xml_response(url, id: id)
    game = process_game(data[:Game])
    game
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
    url = 'GetGamesList.php'
    data = xml_response(url, name: name)
    data[:Game].map { |game| process_game(game) }
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
    url = 'GetArt.php'
    data = xml_response(url, id: id)[:Images]
    data[:logo] = data[:clearlogo].last
    data[:boxart] = process_covers(data[:boxart])
    data
  end

  def self.process_covers(boxart)
    boxart = boxart.flatten

    covers = {}
    boxart.each do |art|
      next unless art.is_a?(Hash)
      covers[art[:side].to_sym] = {
        url: art[:thumb].gsub('thumb/',''),
        width: art[:width],
        height: art[:height],
        thumb: art[:thumb]
      }
    end
    covers
  end

  private

  # Api call and xml parsing
  def self.xml_response(url, params = {})
    uri = URI(BASE_URL + url)
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP.get_response(uri)
    Ox.load(request.body, mode: :hash)[:Data]
  end

  # Process games for platform_games
  def self.process_platform_games(data)
    games = []

    data.first.last.each do |elem|
      name = elem[:GameTitle]
      id = elem[:id].to_i
      date = elem.dig(:ReleaseDate)
      games << { name: name, id: id, release_date: date }
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
end
