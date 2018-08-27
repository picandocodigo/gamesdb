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
      @games_by_id = Gamesdb.platform_games(platforms[0][:id])
      @games_by_slug = Gamesdb.platform_games(platforms[0][:slug])
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
        @platform = Gamesdb.platform 6
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
        images[:boxart][1].must_equal 'platform/boxart/6-2.jpg'
        images[:boxart].first[:width].must_equal '500'
        images[:boxart].first[:height].must_equal '750'
        images[:consoleart].must_equal 'platform/consoleart/6.png'
        images[:controllerart].must_equal 'platform/controllerart/6.png'
      end
    end

    describe 'without hardware or images' do
      before do
        @platform = Gamesdb.platform 4916
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

        images[:boxart][1].must_equal 'platform/boxart/4916-2.jpg'
        images[:boxart].first[:width].must_equal '820'
        images[:boxart].first[:height].must_equal '1080'
        images[:consoleart].must_be_nil
        images[:controllerart].must_be_nil
      end
    end
  end
end
