require 'simplecov'
SimpleCov.start
require 'vcr'
require 'minitest/spec'
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'thegamesdb'

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

    it 'should have a valid slug' do
      @platforms[0][:slug].must_be_kind_of String
    end
  end

  describe 'platform_games' do
    before do
      VCR.insert_cassette('platform_games')
      platforms = Gamesdb.platforms
      @games_by_id = Gamesdb.platform_games(platforms[0][:id])
      @games_by_slug = Gamesdb.platform_games(platforms[0][:slug])
    end

    after do
      VCR.eject_cassette
    end

    it 'should return games in platform by id' do
      @games_by_id.count.wont_be :<, 0
    end

    it 'should return games in platform' do
      @games_by_slug.count.wont_be :<, 0
    end
  end

  describe 'platform' do
    describe 'assigning basic info' do
      before do
        VCR.insert_cassette('nintendo platform')
        @platform = Gamesdb.platform 6
      end

      after do
        VCR.eject_cassette
      end

      it 'should return valid platform info' do
        @platform[:name].must_equal 'Super Nintendo (SNES)'
        @platform[:overview].must_be_kind_of String
        @platform[:developer].must_be_kind_of String
        @platform[:manufacturer].must_equal 'Nintendo'
        @platform[:cpu].must_be_kind_of String
        @platform[:memory].must_be_kind_of String
        @platform[:sound].must_be_kind_of String
        @platform[:display].must_be_kind_of String
      end

      it 'should assign images if provided' do
        images = @platform[:Images]
        images[:boxart][:url].must_equal "platform/boxart/6-2.jpg"
        images[:boxart][:width].must_equal "500"
        images[:boxart][:height].must_equal "750"
        images[:console_art].must_equal "platform/consoleart/6.png"
        images[:controller_image].must_equal "platform/controllerart/6.png"
      end

    end

    describe 'without hardware or images' do
      before do
        VCR.insert_cassette('android platform')
        @platform = Gamesdb.platform 4916
      end

      after do
        VCR.eject_cassette
      end

      it 'should return valid platform info' do
        @platform[:name].must_equal 'Android'
        @platform[:overview].must_be_kind_of String
        @platform[:developer].must_be_kind_of String
        @platform[:manufacturer].must_be_nil
        @platform[:cpu].must_be_nil
        @platform[:memory].must_be_nil
        @platform[:sound].must_be_nil
        @platform[:display].must_be_nil
      end

      it 'should not fail hard if no images are provided' do
        images = @platform[:Images]
        images[:boxart][:url].must_equal "platform/boxart/4916-2.jpg"
        images[:boxart][:width].must_equal "820"
        images[:boxart][:height].must_equal "1080"
        images[:console_art].must_be_nil
        images[:controller_image].must_be_nil
      end
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

  describe 'games art' do
    before do
      VCR.insert_cassette('game_art')
      @images = Gamesdb.art("216")
    end

    after do
      VCR.eject_cassette
    end

    it 'should return logo and boxart' do
      @images[:boxart].count.wont_be :<, 0
      @images[:logo].must_be_kind_of String
      @images[:boxart][:front][:url].must_be_kind_of String
      @images[:boxart][:front][:width].must_be_kind_of String
      @images[:boxart][:front][:height].must_be_kind_of String
      @images[:boxart][:front][:thumb].must_be_kind_of String
    end

    it 'should return screenshots' do
      @images[:screenshots].count.wont_be :<, 0
      @images[:screenshots].first[:url].must_be_kind_of String
      @images[:screenshots].first[:width].must_be_kind_of String
      @images[:screenshots].first[:height].must_be_kind_of String
      @images[:screenshots].first[:thumb].must_be_kind_of String
    end

    it 'should return fanart' do
      @images[:fanart].count.wont_be :<, 0
      @images[:fanart].first[:url].must_be_kind_of String
      @images[:fanart].first[:width].must_be_kind_of String
      @images[:fanart].first[:height].must_be_kind_of String
      @images[:fanart].first[:thumb].must_be_kind_of String
    end
  end
end
