require 'gamesdb/version'
require 'ox'
require 'net/http'

# Client for TheGamesDB API (thegamesdb.net)
module Gamesdb
  BASE_URL = 'http://thegamesdb.net/api/'

  # Method for listing platform's games
  # http://wiki.thegamesdb.net/index.php?title=GetPlatformGames
  #
  # Parameters: platform id (int)
  #
  # == Returns:
  # Array of Hashes with games info
  def self.platform_games(platform)
    url = 'GetPlatformGames.php'
    data = xml_response(url, platform: platform)
    games = []

    data.nodes[0].nodes.each do |elem|
      name = elem.GameTitle.text
      id = elem.id.nodes[0]
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
      slug = nil
      begin
      # TODO: slug
      # slug = platform.alias.text
      rescue NoMethodError
      end
      platforms << { name: name, id: id.to_i, slug: slug }
    end
    platforms
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

  private

  # Api call and xml parsing
  def self.xml_response(url, params = {})
    uri = URI(BASE_URL + url)
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP.get_response(uri)

    Ox.parse(request.body)
  end

  def self.process_game(game)
    images = {}
    game.locate('Images/boxart').each do |a|
      key = a.attributes[:side].to_sym
      images[key] = a.text
    end
    {
      id: game.id.text.to_i, title: game.GameTitle.text,
      release_date: game.ReleaseDate.text, platform: game.Platform.text,
      overview: game.Overview.text, publisher: game.Publisher.text,
      developer: game.Developer.text,
      genres: game.Genres.nodes.map(&:text).join(', '),
      # esrb: game.ESRB.text, rating: game.Rating.text,
      images: images
    }
  end
end
