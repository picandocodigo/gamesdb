require_relative './test_helper.rb'

describe 'Gamesdb - games', :vcr do
  describe 'game' do
    before do
      @game = Gamesdb.game_by_id(109)
    end

    it 'should have a valid id' do
      @game[:id].must_be_kind_of Integer
      @game[:id].must_equal 109
    end

    it 'should have valid fields' do
      @game[:game_title].must_be_kind_of String
      @game[:game_title].length.wont_be :<, 0
    end
  end

  describe 'empty game' do
    before do
      @game = Gamesdb.game_by_id(3)
    end

    it 'should return an empty array' do
      @game.must_equal []
    end
  end

  describe 'games by name' do
    before do
      @games_list = Gamesdb.games_by_name('turrican')
    end

    it 'should return a list' do
      game = @games_list.first
      game[:id].must_be_kind_of Integer
      game[:name].must_be_kind_of String
      game[:platform].must_be_kind_of Integer
      game[:release_date].must_be_kind_of String
    end
  end

  describe 'games by name pages' do
    before do
      @first_page = Gamesdb.games_by_name('mario', page: 1)
      @second_page = Gamesdb.games_by_name('mario', page: 2)
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

  describe 'games by name and platform' do
    before do
      @games_list = Gamesdb.games_by_name('mario', platform: 7)
    end

    it 'should return a list' do
      @games_list.each do |game|
        game[:id].must_be_kind_of Integer
        game[:id].must_be_kind_of Integer
        game[:name].must_be_kind_of String
        game[:platform].must_equal 7
      end
    end
  end

  describe 'games art', :vcr do
    describe 'when most of the art is available' do
      before do
        @images = Gamesdb.game_images('216')
      end

      it 'should return logo and boxart' do
        @images[:boxart].count.wont_be :<, 0
        @images[:logo].must_be_kind_of String
        @images[:boxart][:front][:url].must_be_kind_of String
        @images[:boxart][:front][:width].must_be_kind_of String
        @images[:boxart][:front][:height].must_be_kind_of String
        @images[:boxart][:front][:resolution].must_be_kind_of String
      end

      it 'should return screenshots' do
        @images[:screenshot].count.wont_be :<, 0
        @images[:screenshot].first.must_be_kind_of Hash
        @images[:screenshot].first[:filename].must_be_kind_of String
      end

      it 'should return fanart' do
        @images[:fanart].count.wont_be :<, 0
        @images[:fanart].first[:url].must_be_kind_of String
        @images[:fanart].first[:width].must_be_kind_of String
        @images[:fanart].first[:height].must_be_kind_of String
        @images[:fanart].first[:resolution].must_be_kind_of String
      end
    end

    describe 'when some art is missing' do
      before do
        @images = Gamesdb.game_images(65238)
      end

      it 'should return an empty array' do
        @images.must_be_kind_of Hash
      end
    end
  end
end
