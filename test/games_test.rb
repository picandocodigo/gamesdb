require_relative './test_helper.rb'

describe 'Gamesdb - games', :vcr do
  describe 'game' do
    before do
      @game = Gamesdb.game_by_id(109)
    end

    it 'should have a valid id' do
      expect(@game[:id]).must_be_kind_of Integer
      expect(@game[:id]).must_equal 109
    end

    it 'should have valid fields' do
      expect(@game[:game_title]).must_be_kind_of String
      expect(@game[:game_title].length).wont_be :<, 0
    end
  end

  describe 'empty game' do
    before do
      @game = Gamesdb.game_by_id(3)
    end

    it 'should return an empty array' do
      expect(@game).must_equal []
    end
  end

  describe 'games by name' do
    before do
      @games_list = Gamesdb.games_by_name('turrican')
    end

    it 'should return a list' do
      game = @games_list.first
      expect(game[:id]).must_be_kind_of Integer
      expect(game[:name]).must_be_kind_of String
      expect(game[:platform]).must_be_kind_of Integer
      expect(game[:release_date]).must_be_kind_of String
    end
  end

  describe 'games by name pages' do
    before do
      @first_page = Gamesdb.games_by_name('mario', page: 1)
      @second_page = Gamesdb.games_by_name('mario', page: 2)
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

  describe 'games by name and platform' do
    before do
      @games_list = Gamesdb.games_by_name('mario', platform: 7)
    end

    it 'should return a list' do
      @games_list.each do |game|
        expect(game[:id]).must_be_kind_of Integer
        expect(game[:id]).must_be_kind_of Integer
        expect(game[:name]).must_be_kind_of String
        expect(game[:platform]).must_equal 7
      end
    end
  end

  describe 'games art', :vcr do
    describe 'when most of the art is available' do
      before do
        @images = Gamesdb.game_images('218')
      end

      it 'should return logo and boxart' do
        expect(@images[:boxart].count).wont_be :<, 0
        expect(@images[:logo]).must_be_kind_of String
        expect(@images[:boxart][:front][:url]).must_be_kind_of String
        expect(@images[:boxart][:front][:width]).must_be_kind_of String
        expect(@images[:boxart][:front][:height]).must_be_kind_of String
        expect(@images[:boxart][:front][:resolution]).must_be_kind_of String
      end

      it 'should return screenshots' do
        expect(@images[:screenshot].count).wont_be :<, 0
        expect(@images[:screenshot].first).must_be_kind_of Hash
        expect(@images[:screenshot].first[:filename]).must_be_kind_of String
      end

      it 'should return fanart' do
        expect(@images[:fanart].count).wont_be :<, 0
        expect(@images[:fanart].first[:url]).must_be_kind_of String
        expect(@images[:fanart].first[:width]).must_be_kind_of String
        expect(@images[:fanart].first[:height]).must_be_kind_of String
        expect(@images[:fanart].first[:resolution]).must_be_kind_of String
      end
    end

    describe 'when some art is missing' do
      before do
        @images = Gamesdb.game_images(65238)
      end

      it 'should return an empty array' do
        expect(@images).must_be_kind_of Hash
      end
    end
  end
end
