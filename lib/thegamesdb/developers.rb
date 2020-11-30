# frozen_string_literal: true

module Gamesdb
  # Developers related API Endpoints
  module Developers
    # Fetches Developers list
    #
    # @see https://api.thegamesdb.net/#/Developers/Developers
    #
    # @return Array of Hashes with id and name as keys
    def developers
      url = 'Developers'
      data = perform_request(url)
      data['data']['developers'].map { |_id, developer| developer }
    end
  end
end
