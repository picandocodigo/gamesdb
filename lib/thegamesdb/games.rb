# frozen_string_literal: true

module Gamesdb
  module Games
    # Method for listing platform's games
    #
    # @see https://api.thegamesdb.net/#/Games/GamesByPlatformID
    #
    # @param id [Integer]
    # @param page [Integer]
    #
    # @return [Array] Array of Hashes with games info
    #
    def games_by_platform_id(platform_id, page = 1)
      url = 'Games/ByPlatformID'
      params = { id: platform_id, page: page, include: 'boxart' }
      data = perform_request(url, params)
      process_platform_games(data)
    end

    # Method for getting game info
    #
    # @see https://api.thegamesdb.net/#/Games/GamesByGameID
    #
    # @param id [Integer|String] Game id or string of ',' delimited list
    #
    # @return [Array|Hash] Hash with game info
    #
    def games_by_id(id)
      url = 'Games/ByGameID'
      params = {
        id: id,
        fields: 'players,publishers,genres,overview,last_updated,rating,platform,coop,youtube,os,processor,ram,hdd,video,sound,alternates',
        include: 'boxart,platform'
      }
      data = perform_request(url, params)
      return [] if (data['data']['count']).zero?

      games = data['data']['games']
      return symbolize_keys(games.first) if games.count == 1

      games.map { |game| symbolize_keys(game) }
    end

    # The GetGamesList API search returns a listing of games matched up with loose search terms.
    #
    # @see https://api.thegamesdb.net/#/Games/GamesByGameName
    #
    # @param name [String] game name (required)
    # @param platform [Integer] (optional - platform id)
    # @param page [Integer] (optional)
    #
    # @return [Hash] Hash with game info:  id, name (not-unique), release_date, platform, etc.
    #
    def games_by_name(name, platform: nil, page: 1)
      url = 'Games/ByGameName'
      params = {
        fields: 'players,publishers,genres,overview,last_updated,rating,platform,coop,youtube,os,processor,ram,hdd,video,sound,alternates',
        include: 'boxart',
        name: name,
        page: page
      }
      params.merge!('filter[platform]' => platform) unless platform.nil?

      data = perform_request(url, params)
      process_platform_games(data)
    end

    # This API feature returns a list of available artwork types and
    # locations specific to the requested game id in the database. It
    # also lists the resolution of any images available. Scrapers can be
    # set to use a minimum or maximum resolution for specific images
    #
    # @see https://api.thegamesdb.net/#/Games/GamesImages
    #
    # @param id [Integer] The numeric ID of the game in Gamesdb that you like to fetch artwork details for
    #
    # @return [Hash] Hash with game art info: fanart (array), boxart (Hash, :front, :back),  screenshots (array), fanart (array)
    #
    def games_images(id)
      url = 'Games/Images'
      data = perform_request(url, games_id: id)
      return [] if data.dig('data', 'count') == (0 || nil)

      response = {}
      response[:base_url] = data['data']['base_url']['original']
      response[:logo] = process_logo(data['data'], id)
      response[:boxart] = process_covers(data['data'], id)
      response[:screenshot] = process_screenshots(data['data'], id)
      response[:fanart] = process_fanart(data['data'], id)
      response
    end

    # Fetch games update
    #
    # @see https://api.thegamesdb.net/#/Games/GamesUpdates
    #
    # @param last_edit_id [Integer] Required
    # @param time [Integer] (optional)
    # @param page [Integer] results page offset to return (optional)
    def games_update(last_edit_id, arguments = {})
      url = 'Games/Updates'
      params = arguments.merge({ last_edit_id: last_edit_id })
      data = perform_request(url, params)

      regexp = /page\=([0-9]+)/
      response = {}
      response[:updates] = data['data']['updates']
      response[:previous_page] = data.dig('pages', 'previous')&.match(regexp)&.captures&.first&.to_i
      response[:next_page] = data.dig('pages', 'next')&.match(regexp)&.captures&.first&.to_i
      response
    end
  end
end
