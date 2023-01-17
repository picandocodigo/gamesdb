# frozen_string_literal: true

module Gamesdb
  # Gamesdb errors
  class Error < StandardError
    def initialize(code, status)
      @code = code
      @status = status
      super("Gamesdb: #{code} - #{status}")
    end
  end
end
