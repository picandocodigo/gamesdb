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

* [Get Platforms](#get-platforms)
* [Get Platform Games](#get-platform-games)
* [Get Game](#get-game)
* [Get Games List](#get-game-list)
* [Get Art](#get-art)

### Get Platforms
http://wiki.thegamesdb.net/index.php?title=GetPlatformsList
>The GetGamesList API search returns a listing of a listing of all platforms available on the site, sorted by alphabetical order of name.

**Usage**

* Parameters: none
* Returns: Array with platforms info in Hashes with `:id`, `:name` and `:slug`.

```ruby
$ irb
2.1.2 :001 > require 'gamesdb'
 => true
2.1.2 :002 > Gamesdb.platforms
 => [{:name=>"3DO", :id=>25, :slug=>nil},
 {:name=>"Amiga", :id=>4911, :slug=>nil},
 {:name=>"Amstrad CPC", :id=>4914, :slug=>nil},
 {:name=>"Android", :id=>4916, :slug=>nil},
 {:name=>"Arcade", :id=>23, :slug=>nil},
 {:name=>"Atari 2600", :id=>22, :slug=>nil},
 {:name=>"Atari 5200", :id=>26, :slug=>nil},
 ...
```

### Get Platform Games
http://wiki.thegamesdb.net/index.php?title=GetPlatformGames
>The GetPlatformGames API method returns a listing of all games available on the site for the given platform.

**Usage**

* Parameters: id - the integer id of the required platform, as retrived from GetPlatformsList
* Returns: Array with games info in Hashes with `:id`, `:name` and `:release_date`.

```ruby
2.1.2 :003 > Gamesdb.platform_games(6)
=> [{:name=>"Super Mario Kart", :id=>"41", :release_date=>"09/01/1992"},
{:name=>"Final Fantasy VI", :id=>"83", :release_date=>"04/02/1994"},
{:name=>"Contra III: The Alien Wars", :id=>"122", :release_date=>"04/06/1992"},
{:name=>"Donkey Kong Country", :id=>"131", :release_date=>"11/21/1994"},
{:name=>"Super Mario World", :id=>"136", :release_date=>"11/21/1990"},
{:name=>"Super Mario World 2: Yoshi's Island", :id=>"137", :release_date=>"10/04/1995"},
{:name=>"Mega Man X", :id=>"143", :release_date=>"01/01/1994"},
{:name=>"Teenage Mutant Ninja Turtles IV: Turtles In Time", :id=>"188", :release_date=>"08/01/1992"},
...
```

## Get Game
http://wiki.thegamesdb.net/index.php?title=GetGame
>The GetGameApi title search returns game data in an XML document or if an id is given it just returns the data for that specific game.

**Usage**

* Parameters: id (int): ID representing a specific game
* Returns: Array with games info in Hashes `:id`, `:title`, `:release_date`, `:platform`, `:overview`, `:publisher`, `:developer`, `:genres` (comma separated string), `:images {:front, :back}`

```ruby
2.1.2 :006 > Gamesdb.game(109)
=> {:id=>109,
:title=>"The Legend of Zelda: Twilight Princess",
:release_date=>"11/19/2006",
:platform=>"Nintendo Wii",
:overview=>"In the next chapter in the Legend of Zelda series, Link can transform into a wolf to scour the darkened land of Hyrule. With the help of Midna, a mysterious being, you must guide Link through hordes of foul creatures and challenging bosses using new moves and a new horseback combat system. Many puzzles stand between Link and the fulfillment of his quest, so you must sharpen your wits as you hunt for weapons and items.",
:publisher=>"Nintendo",
:developer=>"Nintendo",
:genres=>"Action, Adventure",
:images=>{:back=>"boxart/original/back/109-1.jpg",
:front=>"boxart/original/front/109-1.jpg"}}
```

## Get Games List
http://wiki.thegamesdb.net/index.php/GetGamesList
>The GetGamesList API search returns a listing of games matched up with loose search terms.  *Note: We have implemented special character stripping and loose word order searching in an attempt to provide better matching and a return a greater number of relevant hits.*

**Usage**

* Parameters: name (String): search string.
* Returns: Hash with game info:  `:id`, `:name` (not-unique), `:release_date`, `platform`

```ruby
2.2.4 :001 > Gamesdb.games_list "Asterix"
 => [{:id=>"2981", :name=>"Asterix", :release_date=>"01/01/1991", :platform=>"Sega Master System"},
 {:id=>"3160", :name=>"Asterix", :release_date=>"01/01/1993", :platform=>"Super Nintendo (SNES)"},
 {:id=>"9243", :name=>"Asterix", :release_date=>"01/01/1983", :platform=>"Atari 2600"},
 {:id=>"21170", :name=>"Asterix", :release_date=>"01/01/1993", :platform=>"Nintendo Game Boy"},
 {:id=>"330", :name=>"Asterix", :release_date=>"03/23/2015", :platform=>"Nintendo Entertainment System (NES)"},
 ...
```

## Get Art
http://wiki.thegamesdb.net/index.php/GetArt
>This API feature returns a list of available artwork types and locations specific to the requested game id in the database. It also lists the resolution of any images available.

**Usage**

* Parameters: id (integer): The numeric ID of the game in Gamesdb
* Returns: Hash with images: `logo`, `boxart` (Hash - front, back), `screenshots`, `fanart`

```ruby
2.2.4 :001 > Gamesdb.art(2208)
 => {
    :logo=>"clearlogo/2208.png",
    :boxart=>
    {
      :front=>{
        :url=>"boxart/original/front/2208-1.jpg", :width=>"2099",
        :height=>"1513",
        :thumb=>"boxart/thumb/original/front/2208-1.jpg"
      },
      :back=>{
        :url=>"boxart/original/front/2208-1.jpg",
        :width=>"2099",
        :height=>"1513",
        :thumb=>"boxart/thumb/original/front/2208-1.jpg"
      }
    },
    :screenshots=>[
      {:url=>"screenshots/2208-1.jpg", :width=>"768", :height=>"672", :thumb=>"screenshots/thumb/2208-1.jpg"},
      {:url=>"screenshots/2208-2.jpg", :width=>"768", :height=>"672", :thumb=>"screenshots/thumb/2208-2.jpg"},
      {:url=>"screenshots/2208-3.jpg", :width=>"768", :height=>"672", :thumb=>"screenshots/thumb/2208-3.jpg"}
    ],
    :fanart=>[]
    }
 ```

## Contributing

1. Fork it ( http://github.com/picandocodogio/gamesdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests and run `rake test` (make sure they pass)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
