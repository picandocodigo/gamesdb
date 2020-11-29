# frozen_string_literal: true

module Gamesdb
  # Platforms related API Endpoints
  module Platforms
    # Method for listing platforms
    #
    # @see https://api.thegamesdb.net/#/Platforms/Platforms
    #
    # @return [Array] Array of Hashes with platforms info
    #
    def platforms
      url = 'Platforms'
      params = { fields:
        'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,'\
          'display,overview,youtube' }
      data = perform_request(url, params)

      data['data']['platforms'].map do |p|
        symbolize_keys(p.last)
      end
    end

    # This API feature returns a set of metadata and artwork data for a specified Platform ID.
    #
    # @see https://api.thegamesdb.net/#/Platforms/PlatformsByPlatformID
    #
    # @param id [Integer|String] The numeric ID of the platform in the GamesDB
    # database or a String with comma delimited list of Ids.
    #
    # @return [Hash|Array] Returns a Hash when there's one result or an Array of
    # Hashes when there's more than one
    #
    def platforms_by_id(id)
      url = 'Platforms/ByPlatformID'
      params = {
        id: id,
        fields:
        'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,' \
        'display,overview,youtube'
      }
      data = perform_request(url, params)

      platform_api_response(data)
    end

    # Fetches platforms by name
    #
    # @see https://api.thegamesdb.net/#/Platforms/PlatformsByPlatformName
    #
    # @param name [String] Platform name (Required)
    #
    # @return [Hash|Array] Returns a Hash when there's one result or an Array of
    # Hashes when there's more than one
    def platforms_by_name(name)
      url = 'Platforms/ByPlatformName'
      params = {
        name: name,
        fields:
        'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,display,' \
        'overview,youtube'
      }
      data = perform_request(url, params)

      platform_api_response(data)
    end

    # Fetch platform(s) images by platform(s) id
    #
    # @see https://api.thegamesdb.net/#/Platforms/PlatformsImages
    #
    # @param platforms_id [Integer|String] The numeric ID of the platform in the GamesDB
    # database or a String with comma delimited list of Ids. (Required)
    # @param filter [String] options: 'fanart', 'banner', 'boxart' (supports
    # comma delimited list)
    # @param page [Integer]
    #
    # @return
    def platform_images(platforms_id, args = {})
      url = 'Platforms/Images'
      args['filter[type]'] = args.delete(:type) if args[:type]
      args = args.merge({ platforms_id: platforms_id })
      data = perform_request(url, args)
      data['data']['images'].values.flatten
    end

    # Auxiliary method to return either one hash when there's only one result or
    # an Array of Hashes for several results
    def platform_api_response(data)
      return [] if data['data']['count'].zero?

      platforms = data['data']['platforms']

      response = case platforms
                 when Hash
                   platforms.map { |_k, platform| symbolize_keys(platform) }
                 when Array
                   platforms.map { |platform| symbolize_keys(platform) }
                 end

      return response.first if response.count == 1

      response
    end
  end
end
