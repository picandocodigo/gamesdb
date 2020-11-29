# frozen_string_literal: true

module Gamesdb
  # Genres related API Endpoints
  module Genres
    # Fetches genres list
    def genres
      url = 'Genres'
      data = perform_request(url)
      data['data']['genres'].map { |_id, genre| genre }
    end
  end
end
