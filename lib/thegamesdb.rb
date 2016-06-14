require 'thegamesdb/version'
require 'ox'
require 'net/http'

# Client for TheGamesDB API (thegamesdb.net)
module Gamesdb
  BASE_URL = 'http://thegamesdb.net/api/'
  IMAGES_BASE_URL = 'http://thegamesdb.net/banners/'

  # Method for listing platform's games
  # http://wiki.thegamesdb.net/index.php?title=GetPlatformGames
  #
  # Parameters: platform id (int) || platform slug (string)
  # For information on how to attain a valid platform slug see `platform`
  #
  # == Returns:
  # Array of Hashes with games info
  def self.platform_games(platform)
    url = (platform.is_a? Numeric) ? 'GetPlatformGames.php' :  'PlatformGames.php'
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

    data.nodes[0].Platforms.nodes.each do |platform|
      id = platform.id.text
      name = platform.nodes[1].text
      slug = platform.respond_to?(:alias) ?  platform.alias.text : ''
      platforms << { name: name, id: id.to_i, slug: slug }
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
    data = xml_response(url, id: id).Data.Platform
    platform = { name: data.Platform.text }
    data.nodes.each do |node|
      platform[node.value.to_sym] = node.text
    end
    if data.Images
      boxart = data.Images.boxart rescue nil
      platform[:Images] = {}
      if boxart
        platform[:Images][:boxart] = {
          url: boxart.text,
          width: boxart.attributes[:width],
          height: boxart.attributes[:height]
        }
      end
      if consoleart = data.Images.consoleart rescue nil
        platform[:Images][:console_art] = consoleart.text
      end
      if controllerart = data.Images.controllerart rescue nil
        platform[:Images][:controller_image] = controllerart.text
      end
    end
    platform
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
    game = data.nodes[0].Game
    process_game(game)
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
    build_games_list(data)
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
    data = xml_response(url, id: id)
    build_images(data.Data.Images)
  end

  private

  # Api call and xml parsing
  def self.xml_response(url, params = {})
    uri = URI(BASE_URL + url)
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP.get_response(uri)
    Ox.parse(request.body)
  end

  # Process games for platform_games
  def self.process_platform_games(data)
    games = []

    data.nodes[0].nodes.each do |elem|
      name = elem.GameTitle.text
      id = elem.id.text
      date = nil
      # TODO: Fix this:
      begin
        date = elem.ReleaseDate.text
      rescue NoMethodError
        # No release date, nothing to do
      end
      games << { name: name, id: id, release_date: date }
    end
    games
  end

  def self.process_game(game)
    images = {}
    game.locate('Images/boxart').each do |a|
      key = a.attributes[:side].to_sym
      images[key] = a.text
    end
    attributes = {
      id: game.id.text.to_i, title: game.GameTitle.text,
      platform: game.Platform.text,
      platform_id: game.PlatformId.text,
      # esrb: game.ESRB.text, rating: game.Rating.text,
      images: images
    }
    attributes[:overview] = game.Overview.text rescue ''
    attributes[:publisher] = game.Publisher.text rescue ''
    attributes[:developer] = game.Developer.text rescue ''
    attributes[:release_date] = game.ReleaseDate.text rescue ''
    attributes[:genres] = game.Genres.nodes.map(&:text) rescue []
    attributes[:coop] = game.send('Co-op').text != 'No' rescue false
    attributes
  end

  def self.build_games_list(data)
    games = []
    data.Data.nodes.each do |node|
      games << {
        id: node.nodes[0].nodes.first,
        name: node.nodes[1].nodes.first,
        release_date: node.nodes[2].nodes.first,
        platform: node.nodes[3].nodes.first
      }
    end
    games
  end

  # Process the XML into a hash with screenshots, box art and fan art
  # The URL's stored are the ones coming from the GamesDB, to access
  # the images append Gamesdb::IMAGES_BASE_URL to the urls.
  def self.build_images(data)
    boxart = data.nodes.select { |a| a.value == "boxart" }
    fanart = data.nodes.select { |a| a.value == "fanart" }
    screenshots = data.nodes.select{ |s| s.value == "screenshot"}
    images = {
      logo: data.clearlogo.text,
      boxart: build_boxart(boxart),
      screenshots: images_from_nodes(screenshots),
      fanart: images_from_nodes(fanart)
    }
    images
  end

  # Get the front and back box art into a Hash
  def self.build_boxart(boxart)
    front = boxart.select { |b| b.attributes[:side] == 'front' }[0]
    back = boxart.pop
    art = {}
    ['front', 'back'].each do |face|
      name = eval(face)
      art[face.to_sym] = {
        url: name.text,
        width: name.attributes[:width],
        height: name.attributes[:height],
        thumb: name.attributes[:thumb]
      }
    end
    art
  end

  # Method for processing the fan art and screenshots into a uniform
  # collection with url, width, height and thumb url
  def self.images_from_nodes(data)
    images = Array.new
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
