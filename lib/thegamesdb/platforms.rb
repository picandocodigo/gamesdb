module Gamesdb
  module Platforms
    # Method for listing platforms
    #
    # @see https://api.thegamesdb.net/#/Platforms/Platforms
    #
    # @return [Array] Array of Hashes with platforms info
    #
    def platforms
      url = 'Platforms'
      params = { fields: 'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,display,overview,youtube' }
      data = perform_request(url, params)

      data['data']['platforms'].map do |p|
        symbolize_keys(p.last)
      end
    end

    # This API feature returns a set of metadata and artwork data for a specified Platform ID.
    #
    # @see https://api.thegamesdb.net/#/Platforms/PlatformsByPlatformID
    #
    # @param id [Integer] The numeric ID of the platform in the GamesDB database
    #
    # @return [Hash] Hash with platform information
    #
    def platforms_by_id(id)
      url = 'Platforms/ByPlatformID'
      params = {
        id: id,
        fields: 'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,display,overview,youtube'
      }
      data = perform_request(url, params)

      platform_api_response(data)
    end

    # Returns platforms by name
    def platforms_by_name(name)
      url = 'Platforms/ByPlatformName'
      params = {
        name: name,
        fields: 'icon,console,controller,developer,manufacturer,media,cpu,memory,graphics,sound,maxcontrollers,display,overview,youtube'
      }
      data = perform_request(url, params)

      platform_api_response(data)
    end

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
