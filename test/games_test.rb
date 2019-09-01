require_relative './test_helper.rb'

describe 'Gamesdb - games', :vcr do
  describe 'game' do
    before do
      @game = Gamesdb.game(109)
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

  describe 'games_list' do
    before do
      @games_list = Gamesdb.games_list('turrican')
    end

    it 'should return a list' do
      game = @games_list.first
      game[:id].must_be_kind_of Integer
      game[:game_title].must_be_kind_of String
      game[:platform].must_be_kind_of Integer
      game[:release_date].must_be_kind_of String
    end
  end

  describe 'games art', :vcr do
    describe 'when most of the art is available' do
      before do
        @images = Gamesdb.art('216')
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
        @images = Gamesdb.art('65238')
      end

      it 'should return logo and boxart' do
        @images[:boxart].count.must_equal 0
        @images[:logo].must_be_kind_of Array
        @images[:logo].must_equal []
      end

      it 'should return screenshots' do
        @images[:boxart].count.must_equal 0
        @images[:logo].must_be_kind_of Array
        @images[:logo].must_equal []
      end

      it 'should return fanart' do
        @images[:boxart].count.must_equal 0
        @images[:logo].must_be_kind_of Array
        @images[:logo].must_equal []
     end
    end
  end
end
