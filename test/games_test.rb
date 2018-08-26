require_relative './test_helper.rb'

describe "Gamesdb - games", :vcr do
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
      @games_list.count.wont_be :<, 0
      game = @games_list.first
      game[:id].must_be_kind_of String
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
