# Gamesdb
A Ruby gem to interact with [TheGamesDB](http://thegamesdb.net) [API](http://wiki.thegamesdb.net/index.php?title=API_Introduction).

[![Build Status](https://api.travis-ci.com/picandocodigo/gamesdb.svg?branch=master)](https://travis-ci.com/picandocodigo/gamesdb)

## Installation

Add this line to your application's Gemfile:

    gem 'thegamesdb'

And then run:

    $ bundle install

Or install it in your system with:

    $ gem install thegamesdb

## Usage

This is still a work in progress, but for now you can use most of the API:


| API call | gem call |
|------------------| ----|
| [GetGamesList](http://wiki.thegamesdb.net/index.php/GetGamesList)         | [Get Games List](#get-games-list)                           |
| [GetGame](http://wiki.thegamesdb.net/index.php/GetGame)                   | [Get Game](#get-game)                                       |
| [GetArt](http://wiki.thegamesdb.net/index.php/GetArt)                     | [Get Art](#get-art)                                         |
| [GetPlatformsList](http://wiki.thegamesdb.net/index.php/GetPlatformsList) | [Get Platforms](#get-platforms)                             |
| [GetPlatform](http://wiki.thegamesdb.net/index.php/GetPlatform)           | [Get Platform](#get-platform)                               |
| [GetPlatformGames](http://wiki.thegamesdb.net/index.php/GetPlatformGames) | [Get Platform Games](#get-platform-games-or-platform-games) |
| [PlatformGames](http://wiki.thegamesdb.net/index.php/PlatformGames)       | [Platform Games](#get-platform-games-or-platform-games)     |
| [Updates](http://wiki.thegamesdb.net/index.php/Updates)                   | _Not implemented yet_                                         |
| [UserRating](http://wiki.thegamesdb.net/index.php/UserRating)             | _Not implemented yet_                                         |
| [UserFavorites](http://wiki.thegamesdb.net/index.php/UserFavorites)       | _Not implemented yet_                                         |



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

### Get Platform Games OR Platform Games
The same method implements `GetPlatformGames` and `PlatformGames`. The first receives the platform id as a parameter, the second one receives the slug. You can find the slug with the GetPlatform method. The return is the same for both methods.

http://wiki.thegamesdb.net/index.php?title=GetPlatformGames
>The GetPlatformGames API method returns a listing of all games available on the site for the given platform.

http://wiki.thegamesdb.net/index.php/PlatformGames
>The PlatformGames API call lists all games under a certain platform.

* Parameters:
  * id - the integer id of the required platform, as retrived from GetPlatformsList
  * platform (string) : the platform slug to list games for (for more information on how to attain a valid platform slug see GetPlatformsList)

* Returns: Array with games info in Hashes with `:id`, `:name` and `:release_date`.

With id:

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

With slug:

```ruby
2.3.1 :001 > Gamesdb.platform_games("3do")
 => [
 {:name=>"Mad Dog McCree", :id=>"6429", :release_date=>"01/01/1994"},
 {:name=>"AD&D: Slayer", :id=>"3143", :release_date=>"01/01/1994"},
 {:name=>"Blade Force", :id=>"4826", :release_date=>"04/05/1995"},
 {:name=>"Battle Chess", :id=>"4829", :release_date=>"01/01/1993"},
 {:name=>"Brain Dead 13", :id=>"4830", :release_date=>"01/01/1996"},
 ...
```

### Get Platform
http://wiki.thegamesdb.net/index.php/GetPlatform
>This API feature returns a set of metadata and artwork data for a specified Platform ID.

**Usage**

* Parameters: id - The numeric ID of the platform in the GamesDB database
* Returns: Hash with platform info

```ruby
2.3.1 :001 > Gamesdb.platform(6)
 => {:name=>"Super Nintendo (SNES)",
 :id=>"6",
 :Platform=>"Super Nintendo (SNES)",
 :console=>"http://www.youtube.com/watch?v=6.png",
 :controller=>"http://www.youtube.com/watch?v=6.png",
 :overview=>"The Super Nintendo Entertainment System (also known as the Super NES, SNES or Super Nintendo) is a 16-bit video game console that was released by Nintendo...",
 :developer=>"Nintendo",
 :manufacturer=>"Nintendo",
 :cpu=>"16-bit 65c816 Ricoh 5A22 3.58 MHz",
 :memory=>"128kb",
 :sound=>"8-bit Sony SPC700",
 :display=>"512 × 239",
 :media=>"Cartridge",
 :maxcontrollers=>"2",
 :Youtube=>"http://www.youtube.com/watch?v=9fSAnVpJ42w",
 :Rating=>"7.5909",
 :Images=>{
   :boxart=>{
     :url=>"platform/boxart/6-2.jpg",
     :width=>"500",
     :height=>"750"
   },
   :console_art=>"platform/consoleart/6.png",
   :controller_image=>"platform/controllerart/6.png"
  }
}
```

### Get Game
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

### Get Games List
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

### Get Art
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
