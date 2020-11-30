# frozen_string_literal: true

module Gamesdb
  # Publishers related API Endpoints
  module Publishers
    def publishers
      url = 'Publishers'

      data = perform_request(url)
      data['data']['publishers'].map do |_id, publisher|
        publisher
      end
    end
  end
end
