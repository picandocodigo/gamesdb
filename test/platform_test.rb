require_relative './test_helper'

describe 'GamesDB - platforms', :vcr do
  describe 'platforms' do
    before do
      @platforms = Gamesdb.platforms
    end

    it 'should get gaming platforms' do
      @platforms.count.wont_be :<, 0
      @platforms.count.must_equal 109
    end

    it 'should have a valid name' do
      @platforms[0][:name].must_be_kind_of String
    end

    it 'should have a valid id' do
      @platforms[0][:id].must_be_kind_of Integer
    end

    it 'should have a valid alias' do
      @platforms[0][:alias].must_be_kind_of String
    end

    it 'should have valid fields for other stuff' do
      nes = @platforms.select { |p| p[:id] == 7 }.first
      nes[:icon].must_be_kind_of String
      nes[:console].must_be_kind_of String
      nes[:controller].must_be_kind_of String
      nes[:developer].must_be_kind_of String
      nes[:manufacturer].must_be_kind_of String
      nes[:maxcontrollers].must_be_kind_of String
      nes[:cpu].must_be_kind_of String
      nes[:memory].must_be_kind_of String
      nes[:sound].must_be_kind_of String
      nes[:display].must_be_kind_of String
      nes[:overview].must_be_kind_of String
    end
  end

  describe 'platform_games pages' do
    before do
      platforms = Gamesdb.platforms
      @first_page = Gamesdb.games_by_platform_id(platforms[0][:id])
      @second_page = Gamesdb.games_by_platform_id(platforms[0][:id], 2)
    end

    it 'should return games in platform by id' do
      @first_page.count.wont_be :<, 0
      @first_page.count.must_equal 20
    end

    it 'should return games in the platform for the second page' do
      @second_page.count.wont_be :<, 0
      @second_page.count.must_equal 20
      (@first_page & @second_page).must_equal []
    end
  end

  describe 'platform' do
    describe 'assigning basic info' do
      before do
        @platform = Gamesdb.platform_by_id(6)
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
    end

    describe 'without hardware or images' do
      before do
        @platform = Gamesdb.platform_by_id 4916
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
    end
  end
end
