module Gamesdb
  class Config
    attr_accessor :api_key
    
    def initialize
      @api_key = ENV['GAMESDB_API_KEY'] || nil
    end
  end
end
