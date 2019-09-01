require_relative './test_helper'

describe 'GamesDB - platforms', :vcr do
  describe 'platforms' do
    before do
      @platforms = Gamesdb.platforms
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
      platforms = Gamesdb.platforms
      @games_by_id = Gamesdb.games_by_platform_id(platforms[0][:id])
    end

    it 'should return games in platform by id' do
      @games_by_id.count.wont_be :<, 0
    end
  end

  describe 'platform' do
    describe 'assigning basic info' do
      before do
        @platform = Gamesdb.platform_by_id 6
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
