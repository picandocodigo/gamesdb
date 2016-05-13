require 'simplecov'
SimpleCov.start

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
      VCR.insert_cassette('platforms')
      @platforms = Gamesdb.platforms
    end

    after do
      VCR.eject_cassette
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
      VCR.insert_cassette('platform_games')
      platforms = Gamesdb.platforms
      @games = Gamesdb.platform_games(platforms[0][:id])
    end

    after do
      VCR.eject_cassette
    end

    it 'should return games in platform' do
      @games.count.wont_be :<, 0
    end
  end

  describe 'game' do
    before do
      VCR.insert_cassette('game')
      @game = Gamesdb.game(109)
    end

    after do
      VCR.eject_cassette
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

  describe 'games_list' do
    before do
      VCR.insert_cassette('games_list')
      @games_list = Gamesdb.games_list('asterix')
    end

    after do
      VCR.eject_cassette
    end

    it 'should return a list' do
      @games_list.count.wont_be :<, 0
      game = @games_list.first
      game[:id].must_be_kind_of String
      game[:name].must_be_kind_of String
      game[:platform].must_be_kind_of String
    end
  end
end
