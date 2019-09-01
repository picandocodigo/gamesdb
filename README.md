# Gamesdb
A Ruby gem to interact with [TheGamesDB](http://thegamesdb.net) API.

It's currently using [the legacy API](http://wiki.thegamesdb.net/index.php/API_Introduction) which is available in read only mode [More info](https://forums.thegamesdb.net/viewtopic.php?f=11&t=86). But it'll be updated to use [the new API endpoints](https://api.thegamesdb.net/), for which you'll need to [request an API key](https://forums.thegamesdb.net/viewforum.php?f=10). I'll keep a way to use the legacy API with a Legacy module anyways.

[![Build Status](https://api.travis-ci.com/picandocodigo/gamesdb.svg?branch=master)](https://travis-ci.com/picandocodigo/gamesdb)
[![Gem Version](https://badge.fury.io/rb/thegamesdb.svg)](https://badge.fury.io/rb/thegamesdb)
[![Maintainability](https://api.codeclimate.com/v1/badges/2dcf3cdcbe37adcea569/maintainability)](https://codeclimate.com/github/picandocodigo/gamesdb/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2dcf3cdcbe37adcea569/test_coverage)](https://codeclimate.com/github/picandocodigo/gamesdb/test_coverage)

## Installation

This gem requires Ruby version 2.3 or more.

Add this line to your application's Gemfile:

    gem 'thegamesdb'

And then run:

    $ bundle install

Or install it in your system with:

    $ gem install thegamesdb

Request an API Key [here](https://forums.thegamesdb.net/viewforum.php?f=10).

## Development

Run all tests:

```
GAMESDB_API_KEY='your_api_key' rake test
```

Run a single test:
```
GAMESDB_API_KEY='your_api_key' rake test TEST=test/platform_test.rb
```

## Usage

For now you can use most of the API:

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
$ rake console
irb(main):001:0> Gamesdb.platforms
=> [{:name=>"3DO", :id=>25, :slug=>"3do"},
{:name=>"Acorn Archimedes", :id=>4944, :slug=>"acorn-archimedes"},
{:name=>"Acorn Electron", :id=>4954, :slug=>"acorn-electron"},
{:name=>"Action Max", :id=>4976, :slug=>"action-max"},
{:name=>"Amiga", :id=>4911, :slug=>"amiga"},
{:name=>"Amiga CD32", :id=>4947, :slug=>"amiga-cd32"},
{:name=>"Amstrad CPC", :id=>4914, :slug=>"amstrad-cpc"},
{:name=>"Android", :id=>4916, :slug=>"android"},
{:name=>"APF MP-1000", :id=>4969, :slug=>"apf-mp-1000"},
{:name=>"Apple II", :id=>4942, :slug=>"apple2"},
{:name=>"Arcade", :id=>23, :slug=>"arcade"},
{:name=>"Atari 2600", :id=>22, :slug=>"atari-2600"},
{:name=>"Atari 5200", :id=>26, :slug=>"atari-5200"},
{:name=>"Atari 7800", :id=>27, :slug=>"atari-7800"},
{:name=>"Atari 800", :id=>4943, :slug=>"atari800"},
{:name=>"Atari Jaguar", :id=>28, :slug=>"atari-jaguar"},
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
irb(main):002:0> Gamesdb.platform_games(6)
=> [{:name=>"Super Mario Kart", :id=>41, :release_date=>"09/01/1992"},
{:name=>"Final Fantasy III", :id=>83, :release_date=>"04/02/1994"},
{:name=>"Contra III: The Alien Wars", :id=>122, :release_date=>"04/06/1992"},
{:name=>"Donkey Kong Country", :id=>131, :release_date=>"11/21/1994"},
{:name=>"Super Mario World", :id=>136, :release_date=>"08/13/1991"},
{:name=>"Super Mario World 2: Yoshi's Island", :id=>137, :release_date=>"10/04/1995"},
{:name=>"Mega Man X", :id=>143, :release_date=>"01/21/1994"},
{:name=>"Teenage Mutant Ninja Turtles IV: Turtles In Time", :id=>188, :release_date=>"08/01/1992"},
...
```

With slug:

```ruby
irb(main):003:0> Gamesdb.platform_games("3do")
=> [
{:name=>"Mad Dog McCree", :id=>6429, :release_date=>"01/01/1994"},
{:name=>"AD&D: Slayer", :id=>3143, :release_date=>"01/01/1994"},
{:name=>"Blade Force", :id=>4826, :release_date=>"04/05/1995"},
{:name=>"Battle Chess", :id=>4829, :release_date=>"01/01/1993"},
{:name=>"Brain Dead 13", :id=>4830, :release_date=>"01/01/1996"},
{:name=>"Burning Soldier", :id=>4831, :release_date=>"11/01/1994"},
{:name=>"Corpse Killer", :id=>4833, :release_date=>"01/01/1994"},
```

### Get Platform
http://wiki.thegamesdb.net/index.php/GetPlatform
>This API feature returns a set of metadata and artwork data for a specified Platform ID.

**Usage**

* Parameters: id - The numeric ID of the platform in the GamesDB database
* Returns: Hash with platform info

```ruby
irb(main):004:0> Gamesdb.platform(6)
=> {
:id=>"6",
:console=>"http://www.youtube.com/watch?v=6.png",
:controller=>"http://www.youtube.com/watch?v=6.png",
:overview=>"The Super Nintendo Entertainment System (also known as the Super NES, SNES or Super Nintendo) is a 16-bit video game console that was released by Nintendo in North America, Europe, Australasia (Oceania), and South America between 1990 and 1993. In Japan and Southeast Asia, the system is called the Super Famicom (officially adopting the abbreviated name of its predecessor, the Family Computer), or SFC for short. In South Korea, it is known as the Super Comboy and was distributed by Hyundai Electronics. Although each version is essentially the same, several forms of regional lockout prevent the different versions from being compatible with one another. The Super Nintendo Entertainment System was Nintendo&#039;s second home console, following the Nintendo Entertainment System (NES). The console introduced advanced graphics and sound capabilities compared with other consoles at the time. Additionally, development of a variety of enhancement chips (which were integrated on game circuit boards) helped to keep it competitive in the marketplace. The SNES was a global success, becoming the best-selling console of the 16-bit era despite its relatively late start and the fierce competition it faced in North America and Europe from Sega&#039;s Genesis console. The SNES remained popular well into the 32-bit era, and although Nintendo no longer offers factory repairs/replacement or accessories for the console, it continues to be popular among fans, collectors, retro gamers, and emulation enthusiasts, some of whom are still making homebrew ROM images.",
:developer=>"Nintendo",
:manufacturer=>"Nintendo",
:cpu=>"16-bit 65c816 Ricoh 5A22 3.58 MHz",
:memory=>"128kb",
:sound=>"8-bit Sony SPC700",
:display=>"512 \xC3\x97 239",
:media=>"Cartridge",
:maxcontrollers=>"2",
:Youtube=>"http://www.youtube.com/watch?v=9fSAnVpJ42w",
:Rating=>"7.8",
:Images=>{
  :fanart=>[
    {:original=>[{:width=>"1920", :height=>"1080"}, "platform/fanart/6-1.jpg"], :thumb=>"platform/fanart/thumb/6-1.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "platform/fanart/6-2.jpg"], :thumb=>"platform/fanart/thumb/6-2.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "platform/fanart/6-3.jpg"], :thumb=>"platform/fanart/thumb/6-3.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "platform/fanart/6-4.jpg"], :thumb=>"platform/fanart/thumb/6-4.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "platform/fanart/6-5.jpg"], :thumb=>"platform/fanart/thumb/6-5.jpg"}
    ],
    :boxart=>[
      {:side=>"back", :width=>"500", :height=>"750"}, "platform/boxart/6-2.jpg"
    ],
    :banner=>[
      [{:width=>"760", :height=>"140"}, "platform/banners/6-1.png"],
      [{:width=>"760", :height=>"140"}, "platform/banners/6-2.jpg"]
    ],
    :consoleart=>"platform/consoleart/6.png",
    :controllerart=>"platform/controllerart/6.png"},
    :name=>"Super Nintendo (SNES)"
}
```

### Get Game
http://wiki.thegamesdb.net/index.php?title=GetGame
>The GetGameApi title search returns game data in an XML document or if an id is given it just returns the data for that specific game.

**Usage**

* Parameters: id (int): ID representing a specific game
* Returns: Array with games info in Hashes `:id`, `:title`, `:release_date`, `:platform`, `:overview`, `:publisher`, `:developer`, `:genres` (comma separated string), `:images {:front, :back}`

```ruby
irb(main):005:0> Gamesdb.game(109)
=> {
:id=>109,
:PlatformId=>"9",
:ReleaseDate=>"11/19/2006",
:Overview=>"Join Link for an legendary adventure on the Wii console. When an evil darkness enshrouds the land of Hyrule, a young farm boy named Link must awaken the hero \xE2\x80\x93 and the animal \xE2\x80\x93 within. When Link travels to the Twilight Realm, he transforms into a wolf and must scour the land with the help of a mysterious girl named Midna. Besides his trusty sword and shield, Link will use his bow and arrows by aiming with the Wii Remote controller, fight while on horseback and use a wealth of other items, both new and old. Features * Arm Link: The Wii Remote and Nunchuk controllers are used for a variety of game activities from fishing to projectile-weapon aiming. The game features incredibly precise aiming control using the Wii Remote controller. Use the controllers for sword swings, spin attacks and shield shoves. * Thrilling Adventure: Players ride into battle against troops of foul creatures and wield a sword and shield with the Wii Remote and Nunchuk controllers, then take on massive bosses that must be seen to be believed. * Mind & Muscle: Many puzzles stand between Link and the fulfillment of his quest, so players must sharpen their wits as they hunt for weapons and items.",
:ESRB=>"T - Teen",
:Genres=>{
  :genre=>["Action", "Adventure", "Platform", "Puzzle", "Role-Playing"]
  },
:Players=>"1",
:"Co-op"=>"No",
:Youtube=>"http://www.youtube.com/watch?v=ceCktUEG4jA",
:Publisher=>"Nintendo",
:Developer=>"Nintendo",
:Rating=>"6.85",
:Similar=>{
  :SimilarCount=>"1",
  :Game=>{:id=>"5434", :PlatformId=>"2"}
},
:Images=>{
  :fanart=>[{:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-1.jpg"], :thumb=>"fanart/thumb/109-1.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-2.jpg"], :thumb=>"fanart/thumb/109-2.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-3.jpg"], :thumb=>"fanart/thumb/109-3.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-4.jpg"], :thumb=>"fanart/thumb/109-4.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-5.jpg"], :thumb=>"fanart/thumb/109-5.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-6.jpg"], :thumb=>"fanart/thumb/109-6.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-7.jpg"], :thumb=>"fanart/thumb/109-7.jpg"}, {:original=>[{:width=>"1920", :height=>"1080"}, "fanart/original/109-8.jpg"], :thumb=>"fanart/thumb/109-8.jpg"}],
  :boxart=>[
    [{:side=>"back", :width=>"1528", :height=>"2156", :thumb=>"boxart/thumb/original/back/109-1.jpg"},"boxart/original/back/109-1.jpg"],
    [{:side=>"front", :width=>"1529", :height=>"2156", :thumb=>"boxart/thumb/original/front/109-1.jpg"}, "boxart/original/front/109-1.jpg"]],
  :banner=>[[{:width=>"760", :height=>"140"}, "graphical/109-g.jpg"], [{:width=>"760", :height=>"140"}, "graphical/109-g2.png"]],
  :screenshot=>{:original=>[{:width=>"603", :height=>"310"}, "screenshots/109-1.jpg"], :thumb=>"screenshots/thumb/109-1.jpg"},
  :clearlogo=>[{:width=>"400", :height=>"277"}, "clearlogo/109.png"]
},
:name=>"The Legend of Zelda: Twilight Princess",
:title=>"The Legend of Zelda: Twilight Princess",
:platform=>"Nintendo Wii"}

```

### Get Games List
http://wiki.thegamesdb.net/index.php/GetGamesList
>The GetGamesList API search returns a listing of games matched up with loose search terms.  *Note: We have implemented special character stripping and loose word order searching in an attempt to provide better matching and a return a greater number of relevant hits.*

**Usage**

* Parameters: name (String): search string.
* Returns: Hash with game info:  `:id`, `:name` (not-unique), `:release_date`, `platform`

```ruby
irb(main):006:0> Gamesdb.games_list "Asterix"
=> [
{:id=>330,:ReleaseDate=>"01/01/1993", :name=>"Asterix", :title=>"Asterix", :platform=>"Nintendo Entertainment System (NES)"},
{:id=>2981, :ReleaseDate=>"01/01/1991", :name=>"Asterix", :title=>"Asterix", :platform=>"Sega Master System"},
{:id=>3160, :ReleaseDate=>"01/01/1993", :name=>"Asterix", :title=>"Asterix", :platform=>"Super Nintendo (SNES)"},
{:id=>9243, :ReleaseDate=>"01/01/1983", :name=>"Asterix", :title=>"Asterix", :platform=>"Atari 2600"},
{:id=>21170, :ReleaseDate=>"06/11/1993", :name=>"Asterix", :title=>"Asterix", :platform=>"Nintendo Game Boy"},
{:id=>21565, :ReleaseDate=>"07/01/1992", :name=>"Asterix", :title=>"Asterix", :platform=>"Arcade"},
{:id=>498, :ReleaseDate=>"09/01/2000", :name=>"Asterix: The Gallic War", :title=>"Asterix: The Gallic War", :platform=>"Sony Playstation"},
{:id=>1572, :ReleaseDate=>"09/28/1995", :name=>"Asterix & Obelix", :title=>"Asterix & Obelix", :platform=>"Super Nintendo (SNES)"},
{:id=>18225, :ReleaseDate=>"07/15/1999", :name=>"Asterix & Obelix", :title=>"Asterix & Obelix", :platform=>"Nintendo Game Boy Color"},
```

### Get Art
http://wiki.thegamesdb.net/index.php/GetArt
>This API feature returns a list of available artwork types and locations specific to the requested game id in the database. It also lists the resolution of any images available.

**Usage**

* Parameters: id (integer): The numeric ID of the game in Gamesdb
* Returns: Hash with images: `logo`, `boxart` (Hash - front, back), `screenshots`, `fanart`

```ruby
irb(main):007:0> Gamesdb.art(2208)
=> {
:boxart=>{
  :back=>{:url=>"boxart/original/back/2208-1.jpg", :width=>"800", :height=>"569", :thumb=>"boxart/thumb/original/back/2208-1.jpg"},
  :front=>{:url=>"boxart/original/front/2208-1.jpg", :width=>"2099", :height=>"1513", :thumb=>"boxart/thumb/original/front/2208-1.jpg"}
},
:screenshot=>[
  {:original=>[{:width=>"768", :height=>"672"}, "screenshots/2208-1.jpg"], :thumb=>"screenshots/thumb/2208-1.jpg"},
  {:original=>[{:width=>"768", :height=>"672"}, "screenshots/2208-2.jpg"], :thumb=>"screenshots/thumb/2208-2.jpg"},
  {:original=>[{:width=>"768", :height=>"672"}, "screenshots/2208-3.jpg"], :thumb=>"screenshots/thumb/2208-3.jpg"}
],
:clearlogo=>[{:width=>"400", :height=>"44"}, "clearlogo/2208.png"],
:logo=>"clearlogo/2208.png"
}
 ```

## Contributing

1. Fork it ( http://github.com/picandocodogio/gamesdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests and run `rake test` (make sure they pass)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
