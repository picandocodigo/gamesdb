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
      @game[:title].must_be_kind_of String
      @game[:title].length.wont_be :<, 0
    end
  end

  describe 'games_list' do
    before do
      @games_list = Gamesdb.games_list('turrican')
    end

    it 'should return a list' do
      game = @games_list.first
      game[:id].must_be_kind_of Integer
      game[:name].must_be_kind_of String
      game[:platform].must_be_kind_of String
    end
  end

  describe 'games art', :vcr do
    before do
      @images = Gamesdb.art('216')
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
      @images[:screenshot].count.wont_be :<, 0
      @images[:screenshot].first[:original][1].must_be_kind_of String
      @images[:screenshot].first[:original].first[:width].must_be_kind_of String
      @images[:screenshot].first[:original].first[:height].must_be_kind_of String
      @images[:screenshot].first[:thumb].must_be_kind_of String
    end

    it 'should return fanart' do
      @images[:fanart].count.wont_be :<, 0
      @images[:fanart].first[:original][1].must_be_kind_of String
      @images[:fanart].first[:original].first[:width].must_be_kind_of String
      @images[:fanart].first[:original].first[:height].must_be_kind_of String
      @images[:fanart].first[:thumb].must_be_kind_of String
    end
  end
end
