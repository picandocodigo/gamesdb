# Gamesdb

A Ruby gem to interact with [TheGamesDB](http://thegamesdb.net) [API](http://wiki.thegamesdb.net/index.php?title=API_Introduction).

## Installation

Add this line to your application's Gemfile:

    gem 'gamesdb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamesdb

## Usage

This is still a work in progress, but for now you can use:

### Get Platforms
http://wiki.thegamesdb.net/index.php?title=GetPlatformsList
>The GetGamesList API search returns a listing of a listing of all platforms available on the site, sorted by alphabetical order of name.

**Usage**

* Parameters: none
* Returns: Array with platforms info in Hashes with `:id`, `:name` and `:slug`.

```
$ irb
2.1.2 :001 > require 'gamesdb'
 => true
2.1.2 :002 > Gamesdb.platforms
 => [{:name=>"3DO", :id=>25, :slug=>nil}, {:name=>"Amiga", :id=>4911, :slug=>nil}, {:name=>"Amstrad CPC", :id=>4914, :slug=>nil}, {:name=>"Android", :id=>4916, :slug=>nil}, {:name=>"Arcade", :id=>23, :slug=>nil}, {:name=>"Atari 2600", :id=>22, :slug=>nil}, {:name=>"Atari 5200", :id=>26, :slug=>nil}, {:name=>"Atari 7800", :id=>27, :slug=>nil}, {:name=>"Atari Jaguar", :id=>28, :slug=>nil}, {:name=>"Atari Jaguar CD", :id=>29, :slug=>nil}, {:name=>"Atari Lynx", :id=>4924, :slug=>nil}, {:name=>"Atari XE", :id=>30, :slug=>nil}, {:name=>"Colecovision", :id=>31, :slug=>nil}, {:name=>"Commodore 64", :id=>40, :slug=>nil},...
```

### Get Platform Games
http://wiki.thegamesdb.net/index.php?title=GetPlatformGames
>The GetPlatformGames API method returns a listing of all games available on the site for the given platform.

**Usage**

* Parameters: id - the integer id of the required platform, as retrived from GetPlatformsList
* Returns: Array with games info in Hashes with `:id`, `:name` and `:release_date`.

```
2.1.2 :003 > Gamesdb.platform_games(6)
=> [{:name=>"Super Mario Kart", :id=>"41", :release_date=>"09/01/1992"}, {:name=>"Final Fantasy VI", :id=>"83", :release_date=>"04/02/1994"}, {:name=>"Contra III: The Alien Wars", :id=>"122", :release_date=>"04/06/1992"}, {:name=>"Donkey Kong Country", :id=>"131", :release_date=>"11/21/1994"}, {:name=>"Super Mario World", :id=>"136", :release_date=>"11/21/1990"}, {:name=>"Super Mario World 2: Yoshi's Island", :id=>"137", :release_date=>"10/04/1995"}, {:name=>"Mega Man X", :id=>"143", :release_date=>"01/01/1994"}, {:name=>"Teenage Mutant Ninja Turtles IV: Turtles In Time", :id=>"188", :release_date=>"08/01/1992"}, {:name=>"Aero Fighters", :id=>"203", :release_date=>"01/01/1994"},...
```

## Get Game
http://wiki.thegamesdb.net/index.php?title=GetGame
>The GetGameApi title search returns game data in an XML document or if an id is given it just returns the data for that specific game.

**Usage**

* Parameters: id (int): ID representing a specific game
* Returns: Array with games info in Hashes `:id`, `:title`, `:release_date`, `:platform`, `:overview`, `:publisher`, `:developer`, `:genres` (comma separated string), `:images {:front, :back}`

```
2.1.2 :006 > Gamesdb.game(109)
=> {:id=>109, :title=>"The Legend of Zelda: Twilight Princess", :release_date=>"11/19/2006", :platform=>"Nintendo Wii", :overview=>"In the next chapter in the Legend of Zelda series, Link can transform into a wolf to scour the darkened land of Hyrule. With the help of Midna, a mysterious being, you must guide Link through hordes of foul creatures and challenging bosses using new moves and a new horseback combat system. Many puzzles stand between Link and the fulfillment of his quest, so you must sharpen your wits as you hunt for weapons and items.", :publisher=>"Nintendo", :developer=>"Nintendo", :genres=>"Action, Adventure", :images=>{:back=>"boxart/original/back/109-1.jpg", :front=>"boxart/original/front/109-1.jpg"}}
```

## Contributing

1. Fork it ( http://github.com/picandocodogio/gamesdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
