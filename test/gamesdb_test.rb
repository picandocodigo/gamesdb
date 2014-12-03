require 'vcr'
require 'minitest/spec'
require 'minitest/autorun'
require 'gamesdb'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

describe Gamesdb do

  describe 'platforms' do
    before do
      VCR.use_cassette('platforms') do
        @platforms = Gamesdb.platforms
      end
    end

    it 'should get gaming platforms' do
      @platforms.count.wont_be :<, 0
    end

    it 'should have a valid name' do
      @platforms[0][:name].must_be_kind_of String
    end

    it 'should have a valid id' do
      @platforms[0][:id].must_be_kind_of Integer
    end
  end

  describe 'platform_games' do
    before do
      VCR.use_cassette('platform_games') do
        platforms = Gamesdb.platforms
        @games = Gamesdb.platform_games(platforms[0][:id])
      end
    end

    it 'should return games in platform' do
      @games.count.wont_be :<, 0
    end
  end

  describe 'game' do
    before do
      VCR.use_cassette('game') do
        @game = Gamesdb.game(109)
      end
    end

    it 'should have a valid id' do
      @game[:id].must_be_kind_of Integer
      @game[:id].must_equal 109
    end

    it 'should have valid fields' do
      @game[:title].must_be_kind_of String
      @game[:title].length.wont_be :<, 0
    end
  end
end
