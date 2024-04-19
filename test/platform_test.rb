# frozen_string_literal: true

require_relative './test_helper'

describe 'GamesDB - platforms', :vcr do
  let(:client) { Gamesdb::Client.new(ENV['GAMESDB_API_KEY']) }

  describe 'platforms' do
    before do
      VCR.use_cassette('platforms') do
        @platforms = client.platforms
      end
    end

    it 'should get gaming platforms' do
      expect(@platforms.count).wont_be :<, 0
      expect(@platforms.count).must_equal 150
    end

    it 'should have a valid name' do
      expect(@platforms[0][:name]).must_be_kind_of String
    end

    it 'should have a valid id' do
      expect(@platforms[0][:id]).must_be_kind_of Integer
    end

    it 'should have a valid alias' do
      expect(@platforms[0][:alias]).must_be_kind_of String
    end

    it 'should have valid fields for other stuff' do
      nes = @platforms.select { |p| p[:id] == 7 }.first
      expect(nes[:icon]).must_be_kind_of String
      expect(nes[:console]).must_be_kind_of String
      expect(nes[:controller]).must_be_kind_of String
      expect(nes[:developer]).must_be_kind_of String
      expect(nes[:manufacturer]).must_be_kind_of String
      expect(nes[:maxcontrollers]).must_be_kind_of String
      expect(nes[:cpu]).must_be_kind_of String
      expect(nes[:memory]).must_be_kind_of String
      expect(nes[:sound]).must_be_kind_of String
      expect(nes[:display]).must_be_kind_of String
      expect(nes[:overview]).must_be_kind_of String
    end
  end

  describe 'games by platform' do
    before do
      VCR.use_cassette('games by platform') do
        platforms = client.platforms
        @first_page = client.games_by_platform_id(platforms[0][:id])
        @second_page = client.games_by_platform_id(platforms[0][:id], 2)
      end
    end

    it 'should return games in platform by id' do
      expect(@first_page.count).wont_be :<, 0
      expect(@first_page.count).must_equal 20
    end

    it 'should return games in the platform for the second page' do
      expect(@second_page.count).wont_be :<, 0
      expect(@second_page.count).must_equal 20
      expect(@first_page & @second_page).must_equal []
    end
  end

  describe 'games by platform parameters' do
    before do
      VCR.use_cassette('games by platform parameters') do
        @games1 = client.games_by_platform_id(4950)
        @games2 = client.games_by_platform_id(4948)
        @games3 = client.games_by_platform_id('4950,4948')
      end
    end

    it 'supports comma separated list' do
      expect(@games1.count).must_equal 20
      expect(@games2.count).must_equal 20
      expect(@games3.count).must_equal 20

      expect(@games3 - @games1).must_equal @games2
    end
  end

  describe 'platform' do
    describe 'assigning basic info' do
      before do
        VCR.use_cassette('platform basic info') do
          @platform = client.platforms_by_id(6)
        end
      end

      it 'should return valid platform info' do
        expect(@platform[:name]).must_equal 'Super Nintendo (SNES)'
        expect(@platform[:overview]).must_be_kind_of String
        expect(@platform[:developer]).must_be_kind_of String
        expect(@platform[:manufacturer]).must_equal 'Nintendo'
        expect(@platform[:cpu]).must_be_kind_of String
        expect(@platform[:memory]).must_be_kind_of String
        expect(@platform[:sound]).must_be_kind_of String
        expect(@platform[:display]).must_be_kind_of String
      end
    end

    describe 'without hardware or images' do
      before do
        VCR.use_cassette('platform without hardware images') do
          @platform = client.platforms_by_id(4916)
        end
      end

      it 'should return valid platform info' do
        expect(@platform[:name]).must_equal 'Android'
        expect(@platform[:overview]).must_be_kind_of String
        expect(@platform[:developer]).must_be_kind_of String
        expect(@platform[:manufacturer]).must_be_nil
        expect(@platform[:cpu]).must_be_nil
        expect(@platform[:memory]).must_be_nil
        expect(@platform[:sound]).must_be_nil
        expect(@platform[:display]).must_be_nil
      end
    end
  end

  describe 'platforms by name' do
    it 'should return platforms' do
      VCR.use_cassette('platforms by name') do
        @platforms = client.platforms_by_name('Nintendo')

        expect(@platforms.count).must_equal 14
        names = @platforms.sort_by { |p| p[:name] }.map { |p| p[:name] }
        expect(names).must_equal [
          'Nintendo 3DS', 'Nintendo 64', 'Nintendo DS', 'Nintendo Entertainment System (NES)',
          'Nintendo Game Boy', 'Nintendo Game Boy Advance', 'Nintendo Game Boy Color', 'Nintendo GameCube',
          'Nintendo Pokémon Mini', 'Nintendo Switch', 'Nintendo Virtual Boy', 'Nintendo Wii', 'Nintendo Wii U',
          'Super Nintendo (SNES)'
        ]
      end
    end
  end

  describe 'platform images' do
    it 'should return all images for a platform' do
      VCR.use_cassette('all images platform') do
        @images = client.platform_images(7)

        expect(@images.count).must_equal(10)
        expect(@images.first.keys).must_equal(['id', 'type', 'filename'])
      end
    end

    it 'should filter image type for a platform' do
      VCR.use_cassette('filter image type platform') do
        @images = client.platform_images(7, type: 'boxart')

        expect(@images.count).must_equal(1)
        expect(@images.first).must_equal({ 'id' => 222, 'type' => 'boxart', 'filename' => 'platform/boxart/7-2.jpg' })
      end
    end
  end
end
