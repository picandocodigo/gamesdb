# Gamesdb 🎮 🕹
A Ruby gem to interact with [TheGamesDB](http://thegamesdb.net) API.

The Legacy API has been shutdown. The gem is now using the new API and you need to [request an API key](https://forums.thegamesdb.net/viewforum.php?f=10) to use it.

[![Tests](https://github.com/picandocodigo/gamesdb/actions/workflows/main.yml/badge.svg)](https://github.com/picandocodigo/gamesdb/actions/workflows/main.yml)
[![Gem Version](https://badge.fury.io/rb/thegamesdb.svg)](https://badge.fury.io/rb/thegamesdb)
[![Maintainability](https://api.codeclimate.com/v1/badges/2dcf3cdcbe37adcea569/maintainability)](https://codeclimate.com/github/picandocodigo/gamesdb/maintainability)

* [Installation and Quick Start](#installation-and-quick-start)
* [General Usage](#usage)
  * [Games](#games)
    * [Games/ByGameID](#gamesbygameid)
    * [Games/ByGameName](#gamesbygamename)
    * [Games/ByGamePlaformID](#gamesbyplatformid)
    * [Games/Images](#gamesimages)
    * [Games/Updates](#gamesupdates)
  * [Platforms](#platforms)
    * [Platforms](#platforms-1)
    * [Platforms/ByPlatformID](#platformsbyplatformid)
    * [Platforms/ByPlatformName](#platformsbyplatformname)
    * [Platforms/Images](#platformsimages)
  * [Genres](#genres)
  * [Developers](#developers)
  * [Publishers](#publishers)
* [RubyDoc](https://www.rubydoc.info/gems/thegamesdb)
* [Development](#development)
* [Contributing](#contributing)


## Installation and Quick Start

This gem requires Ruby version 2.5 or more. Add this line to your application's Gemfile:

    gem 'thegamesdb'

And run:

    $ bundle install

Or install it in your system with:

    $ gem install thegamesdb

To use this library, you'll need to request an API Key [here](https://forums.thegamesdb.net/viewforum.php?f=10). Once you have an API key, you can instantiate a Client:

```ruby
> client = Gamesdb::Client.new('<API_KEY>')
> response = client.platforms
```

**API Key allowances**

The base API Response includes the `remaining_monthly_allowance` for your API key, `extra_allowance` and `allowance_refresh_timer`. These values are updated on the client instance on every request so you can use `client.remaining_monthly_client` to check how many requests the API key has left.

## Usage

The full documentation for the API is available [here](API Documentation: https://api.thegamesdb.net/). Here are the endpoints available on the gem:

### Games


#### Games/ByGameID
- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Games#games_by_id-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Games/GamesByGameID)**

Usage:

```ruby
> client.games_by_id(6177)
 => {
  :id=>6177,
  :game_title=>"Super Turrican",
  :release_date=>"1993-05-01",
  :platform=>6,
  :players=>1,
  :overview=>"Super Turrican is the next generation installment of the famous Turrican Series. Once again it is up to the U.S.S. Freedom Forces to get into their Turrican Assault Suits and drive back the forces of \"The Machine\".\r\n\r\nSimilar to it's predecessors, Super Turican features large levels that are crammed with secrets and can be explored freely and in any direction. To get rid of the numerous enemies, Turrican can use three upgradeable shots: A spreadshot, a powerful laser and a rebound that bounces off of walls. Additionally, there is a Freeze-Beam that can be used to temporarily freeze enemies. It is fully rotatable, and therefor also a great help in discovering secret capsules. These capsules contain powerups and can often be used to reach secret areas. Last but not least, Turrican has the ability to transform into an energy wheel (as long as he has enough special energy), which enables him to lay mines and even makes him invincible.",
  :last_updated=>"2018-07-11 21:05:25",
  :rating=>"T - Teen",
  :coop=>"No",
  :youtube=>nil,
  :os=>nil,
  :processor=>nil,
  :ram=>nil,
  :hdd=>nil,
  :video=>nil,
  :sound=>nil,
  :developers=>[2976],
  :genres=>[8],
  :publishers=>[454],
  :alternates=>nil
 }
```

Supports both an Array of ids or comma delimited list:

```ruby
> client.games_by_id("6177, 6178")
 => [
  {:id=>6177, :game_title=>"Super Turrican", :release_date=>"1993-05-01", :platform=>6, :players=>1, :overview=>"Super Turrican is the next generation installment of the famous Turrican Series. Once again it is up to the U.S.S. Freedom Forces to get into their Turrican Assault Suits and drive back the forces of \"The Machine\".\r\n\r\nSimilar to it's predecessors, Super Turican features large levels that are crammed with secrets and can be explored freely and in any direction. To get rid of the numerous enemies, Turrican can use three upgradeable shots: A spreadshot, a powerful laser and a rebound that bounces off of walls. Additionally, there is a Freeze-Beam that can be used to temporarily freeze enemies. It is fully rotatable, and therefor also a great help in discovering secret capsules. These capsules contain powerups and can often be used to reach secret areas. Last but not least, Turrican has the ability to transform into an energy wheel (as long as he has enough special energy), which enables him to lay mines and even makes him invincible.", :last_updated=>"2018-07-11 21:05:25", :rating=>"T - Teen", :coop=>"No", :youtube=>nil, :os=>nil, :processor=>nil, :ram=>nil, :hdd=>nil, :video=>nil, :sound=>nil, :developers=>[2976], :genres=>[8], :publishers=>[454], :alternates=>nil},
  {:id=>6178, :game_title=>"Super Turrican 2", :release_date=>"1995-11-01", :platform=>6, :players=>1, :overview=>"Twice the Firepower, Twice the burn.\r\n\r\nIf you haven’t played Super Turrican, chances are you won’t last past the intro sequence here... As an intergalactic hero-wannabe commissioned to crush a venomous mutant armada, you are thrust into a chaotic world even more violent than the original. This time there are more enemies to torch (and be torched by)-including the most heinous level bosses on 16-bit-and enough Mode7 graphic levels to make you wish mommy were there to hold your hand. But she’ll be busy cleaning up your charred carcass.\r\n\r\nSuper Turrican 2. Feel the burn.", :last_updated=>"2019-01-24 13:38:26", :rating=>"T - Teen", :coop=>"No", :youtube=>"", :os=>nil, :processor=>nil, :ram=>nil, :hdd=>nil, :video=>nil, :sound=>nil, :developers=>[2976], :genres=>[8], :publishers=>[43], :alternates=>nil}
 ]
```

#### Games/ByGameName

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Games#games_by_name-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Games/GamesByGameName)**

Usage:

```ruby
> client.games_by_name("Mario Kart")
 => [
   {:id=>266, :game_title=>"Mario Kart 64", :release_date=>"1997-02-10", :platform=>3, :developers=>[6037]},
   {:id=>47050, :game_title=>"Mario Kart 64", :release_date=>"2016-12-29", :platform=>38, :developers=>[6037]},
   {:id=>55187, :game_title=>"Mario Kart 64 (VC)", :release_date=>"2007-01-29", :platform=>9, :developers=>[6041]},
   {:id=>64547, :game_title=>"Mario Kart 64 [Not for Resale]", :release_date=>"1997-02-10", :platform=>3, :developers=>nil},
   {:id=>12733, :game_title=>"Mario Kart 7", :release_date=>"2011-12-04", :platform=>4912, :developers=>[7160]},
   {:id=>17444, :game_title=>"Mario Kart 8", :release_date=>"2014-05-30", :platform=>38, :developers=>[6037]},
   {:id=>42294, :game_title=>"Mario Kart 8 Deluxe", :release_date=>"2017-04-28", :platform=>4971, :developers=>[6037]},
   {:id=>10750, :game_title=>"Mario Kart Arcade GP", :release_date=>"2005-10-12", :platform=>23, :developers=>[5804]}, ...
 ]
```
#### Games/ByPlatformID

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Games#games_by_platform_id-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Games/GamesByPlatformID)**

Usage:

```ruby
> client.games_by_platform_id(7)
 => [
   {:name=>"Donkey Kong", :id=>5, :release_date=>"1982-01-01", :developers=>[6037]},
   {:name=>"Bionic Commando", :id=>76, :release_date=>"1988-12-06", :developers=>[1436]},
   {:name=>"Super Mario Bros. 3", :id=>112, :release_date=>"1990-02-12", :developers=>[6055]},
   {:name=>"The Legend of Zelda", :id=>113, :release_date=>"1987-07-01", :developers=>[6055]},
   {:name=>"Kirby's Adventure", :id=>121, :release_date=>"1993-03-26", :developers=>[3694]},
   {:name=>"Metroid", :id=>123, :release_date=>"1987-08-15", :developers=>[6051]},
   {:name=>"Mega Man 5", :id=>125, :release_date=>"1992-12-04", :developers=>[1436]},
   {:name=>"Kid Icarus", :id=>130, :release_date=>"1986-12-18", :developers=>[6037]},
   {:name=>"Lemmings", :id=>133, :release_date=>"1991-02-14", :developers=>[2404]},
   {:name=>"Castlevania", :id=>135, :release_date=>"1987-05-01", :developers=>[4765]},
   {:name=>"Super Mario Bros.", :id=>140, :release_date=>"1985-09-13", :developers=>[6042]}, ...
 ]
```

Supports comma delimited list:

```ruby
> client.games_by_platform_id("4950,4948")
```

#### Games/Images

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Games#games_images-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Games/GamesImages)**

Usage:

```ruby
> client.games_images(121)
 => {
   :base_url=>"https://cdn.thegamesdb.net/images/original/",
   :logo=>"clearlogo/121.png",
   :boxart=>{
     :front=>{:url=>"boxart/front/121-1.jpg", :resolution=>"1536x2100", :width=>"1536", :height=>"2100"},
     :back=>{:url=>"boxart/back/121-1.jpg", :resolution=>"1539x2100", :width=>"1539", :height=>"2100"}
   },
   :screenshot=>[
     {:id=>104578, :type=>"screenshot", :side=>nil, :filename=>"screenshots/121-1.jpg", :resolution=>nil},
     {:id=>104580, :type=>"screenshot", :side=>nil, :filename=>"screenshots/121-2.jpg", :resolution=>nil}
   ],
   :fanart=>[
     {:url=>"fanart/121-1.jpg", :resolution=>"1920x1080", :width=>"1920", :height=>"1080"},
     {:url=>"fanart/121-2.jpg", :resolution=>"1920x1080", :width=>"1920", :height=>"1080"}
   ]
}
```

#### Games/Updates

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Games#games_update-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Games/GamesUpdates)**

Usage:

```ruby
> client.games_update(1000)
   => {:updates=> [
     {"edit_id"=>1001, "game_id"=>60054, "timestamp"=>"2018-07-02 05:54:36", "type"=>"publisher", "value"=>"Semi Secret Software"},
     {"edit_id"=>1002, "game_id"=>60054, "timestamp"=>"2018-07-02 05:54:36", "type"=>"youtube", "value"=>""},
     {"edit_id"=>1003, "game_id"=>60054, "timestamp"=>"2018-07-02 05:54:36", "type"=>"platform", "value"=>"4916"},
     {"edit_id"=>1004, "game_id"=>60054, "timestamp"=>"2018-07-02 05:54:36", "type"=>"genre", "value"=>"|Action|"},
     {"edit_id"=>1005, "game_id"=>60054, "timestamp"=>"2018-07-02 05:54:36", "type"=>"rating", "value"=>"E10+ - Everyone 10+"},
     {"edit_id"=>1006, "game_id"=>60054, "timestamp"=>"2018-07-02 05:57:09", "type"=>"series", "value"=>"series/60054-1.jpg"},
     {"edit_id"=>1007, "game_id"=>55249, "timestamp"=>"2018-07-02 05:57:17", "type"=>"boxart", "value"=>"boxart/front/55249-1.jpg"},
     {"edit_id"=>1008, "game_id"=>60054, "timestamp"=>"2018-07-02 05:57:26", "type"=>"boxart", "value"=>"boxart/front/60054-1.jpg"},
     {"edit_id"=>1009, "game_id"=>60055, "timestamp"=>"2018-07-02 05:57:37", "type"=>"game", "value"=>"[NEW]"},
     {"edit_id"=>1010, "game_id"=>60055, "timestamp"=>"2018-07-02 05:57:37", "type"=>"game_title", "value"=>"Star Breaker"},
     ...
     ],
     :previous_page=>nil,
     :next_page=>2
     }
```

Pages:

```ruby
>response = client.games_update(1000, page: 100)
   => {:updates=> [
   {"edit_id"=>11073, "game_id"=>36224, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[1044]},
   {"edit_id"=>11074, "game_id"=>36229, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[1044]},
   {"edit_id"=>11075, "game_id"=>36230, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[1044]},
   {"edit_id"=>11076, "game_id"=>36252, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[47]},
   {"edit_id"=>11077, "game_id"=>36284, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[1044]},
   {"edit_id"=>11078, "game_id"=>36379, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[1044]},
   {"edit_id"=>11079, "game_id"=>36740, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[171]},
   {"edit_id"=>11080, "game_id"=>36757, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[731]},
   {"edit_id"=>11081, "game_id"=>36777, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[309]},
   {"edit_id"=>11082, "game_id"=>36785, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[731]},
   ...
 ],
 :previous_page=>99,
 :next_page=>101
 }
>next_page = client.games_update(1000, page: response[:next_page])
   => {:updates=> [
        {"edit_id"=>11173, "game_id"=>48037, "timestamp"=>"2018-07-27 23:10:44", "type"=>"publishers", "value"=>[1044]},
        ],
        :previous_page=>100,
        :next_page=>102
     }
```


### Platforms

#### Platforms

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Platforms#platforms-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Platforms/Platforms)**

Usage:
```ruby
> client.platforms
=> [
 {:name=>"3DO", :id=>25, :slug=>"3do"},
 {:name=>"Acorn Archimedes", :id=>4944, :slug=>"acorn-archimedes"},
 {:name=>"Acorn Electron", :id=>4954, :slug=>"acorn-electron"},
 {:name=>"Action Max", :id=>4976, :slug=>"action-max"},
 {:name=>"Amiga", :id=>4911, :slug=>"amiga"},
 {:name=>"Amiga CD32", :id=>4947, :slug=>"amiga-cd32"},
 {:name=>"Amstrad CPC", :id=>4914, :slug=>"amstrad-cpc"},
 {:name=>"Android", :id=>4916, :slug=>"android"},
 ...
```

#### Platforms/ByPlatformID

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Platforms#platforms_by_id-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Platforms/PlatformsByPlatformID)**

Usage:
```ruby
> client.platform_by_id(7)
 => {
   :id=>7,
   :name=>"Nintendo Entertainment System (NES)",
   :alias=>"nintendo-entertainment-system-nes",
   :icon=>"nintendo-entertainment-system-nes-1336524652.png",
   :console=>"7.png",
   :controller=>"7.png",
   :developer=>"Nintendo",
   :manufacturer=>"Nintendo",
   :media=>"Cartridge",
   :cpu=>"Ricoh 2A03",
   :memory=>"2KB RAM",
   :graphics=>"RP2C02",
   :sound=>"Pulse Code Modulation",
   :maxcontrollers=>"2",
   :display=>"RGB",
   :overview=>"The Nintendo Entertainment System (also abbreviated as NES or simply called Nintendo) is an 8-bit video game console that was released by Nintendo in North America during 1985, in Europe during 1986 and Australia in 1987. In most of Asia, including Japan (where it was first launched in 1983), China, Vietnam, Singapore, the Middle East and Hong Kong, it was released as the Family Computer, commonly shortened as either the romanized contraction Famicom, or abbreviated to FC. In South Korea, it was known as the Hyundai Comboy, and was distributed by Hynix which then was known as Hyundai Electronics.\r\n\r\nAs the best-selling gaming console of its time, the NES helped revitalize the US video game industry following the video game crash of 1983, and set the standard for subsequent consoles of its generation. With the NES, Nintendo introduced a now-standard business model of licensing third-party developers, authorizing them to produce and distribute software for Nintendo&#039;s platform.",
   :youtube=>nil
}
```

#### Platforms/ByPlatformName

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Platforms#platforms_by_name-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Platforms/PlatformsByPlatformName)**

Usage:
```ruby
> client.platforms_by_name("Nintendo")
=> [
  {:id=>4912, :name=>"Nintendo 3DS", :alias=>"nintendo-3ds", :icon=>"nintendo-3ds-1344286647.png", :console=>"4912.png", :controller=>nil, :developer=>"Nintendo", :manufacturer=>"Nintendo", :media=>"Cartridge", :cpu=>"Nintendo ARM", :memory=>"128 MB FCRAM", :graphics=>"PICA200 by Digital Media Professionals", :sound=>nil, :maxcontrollers=>"1", :display=>"800 × 240 px (effectively 400 × 240 WQVGA per eye)", :overview=>"...", :youtube=>nil},
  {:id=>3, :name=>"Nintendo 64", :alias=>"nintendo-64", :icon=>"nintendo-64-1336524631.png", :console=>"3.png", :controller=>"3.png", :developer=>"Nintendo", :manufacturer=>"Nintendo", :media=>"Cartridge", :cpu=>"93.75 MHz NEC VR4300", :memory=>"4 MB RDRAM (8 MB with Expansion Pack)", :graphics=>"62.5 MHz SGI RCP", :sound=>"48 kHz with 16-bit audio", :maxcontrollers=>"4", :display=>"320 x 240 or 640 x 480 (supported by Expansion Pack)", :overview=>"...", :youtube=>"Up9jO2l2wqo"},
  {:id=>8, :name=>"Nintendo DS", :alias=>"nintendo-ds", :icon=>"nintendo-ds-1336524642.png", :console=>"8.png", :controller=>nil, :developer=>"Nintendo", :manufacturer=>"Foxconn", :media=>"Cartridge", :cpu=>"ARM9", :memory=>"4 MB RAM", :graphics=>"ARM946E-S", :sound=>"ARM7TDMI", :maxcontrollers=>"1", :display=>"256 × 192", :overview=>"...", :youtube=>nil},
  {:id=>7, :name=>"Nintendo Entertainment System (NES)", :alias=>"nintendo-entertainment-system-nes", :icon=>"nintendo-entertainment-system-nes-1336524652.png", :console=>"7.png", :controller=>"7.png", :developer=>"Nintendo", :manufacturer=>"Nintendo", :media=>"Cartridge", :cpu=>"Ricoh 2A03", :memory=>"2KB RAM", :graphics=>"RP2C02", :sound=>"Pulse Code Modulation", :maxcontrollers=>"2", :display=>"RGB", :overview=>"..."}, (...)
]
```

#### Platforms/Images

- **[Swagger API Documentation](https://api.thegamesdb.net/#/Platforms/PlatformsImages)**

Usage:
```ruby
> client.platform_images(7)
 => [
   {"id"=>22, "type"=>"banner", "filename"=>"platform/banners/7-1.png"},
   {"id"=>38, "type"=>"fanart", "filename"=>"platform/fanart/7-1.jpg"},
   {"id"=>39, "type"=>"fanart", "filename"=>"platform/fanart/7-2.jpg"},
   {"id"=>60, "type"...
```

Using a filter for type:
```ruby
 > client.platform_images(7, filter: 'boxart')
 => [{"id"=>222, "type"=>"boxart", "filename"=>"platform/boxart/7-2.jpg"}]
```

### Genres

- **[RubyDoc](https://www.rubydoc.info/github/picandocodigo/gamesdb/master/Gamesdb/Genres#genres-instance_method)**
- **[Swagger API Documentation](https://api.thegamesdb.net/#/Genres/Genres)**

Usage:

```ruby
> client.genres
 => [
  {"id"=>1, "name"=>"Action"},
  {"id"=>2, "name"=>"Adventure"},
  {"id"=>20, "name"=>"Board"},
  {"id"=>3, "name"=>"Construction and Management Simulation"},
  {"id"=>21, "name"=>"Education"},
  ...
]

```

### Developers

- **[Swagger API Documentation](https://api.thegamesdb.net/#/Developers/Developers)**

Usage:

```ruby
> client.developers
  => [
   {"id"=>142, "name"=>"?"},
   {"id"=>9916, "name"=>".dat"},
   {"id"=>2, "name"=>".theprodukkt"},
   {"id"=>9898, "name"=>"[adult swim] games"},
   {"id"=>9899, "name"=>"[bracket]games"},
   {"id"=>9900, "name"=>"[erka:es]"},
   {"id"=>10472, "name"=>"[RON]"},
   {"id"=>9901, "name"=>"][ Games Inc"},
   {"id"=>145, "name"=>"@nifty"},
   ...
 ]
```

### Publishers

- **[Swagger API Documentation](https://api.thegamesdb.net/#/Publishers/Publishers)**

Usage:

```ruby
 > client.publishers
   => [
    {"id"=>2374, "name"=>".GEARS Studios"},
    {"id"=>2090, "name"=>"1-Pup Games"},
    {"id"=>4045, "name"=>"10 out of 10"},
    {"id"=>5898, "name"=>"10Ants Hill"},
    {"id"=>3542, "name"=>"10tons Ltd."},
    {"id"=>1188, "name"=>"11 bit studios"},
    ...
   ]
```

## Development

Run all tests:

```
GAMESDB_API_KEY='your_api_key' rake test
```

Run a single test:
```
GAMESDB_API_KEY='your_api_key' rake test TEST=test/platform_test.rb
```

## Contributing

1. Fork it ( http://github.com/picandocodogio/gamesdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests and run `GAMESDB_API_KEY='your_api_key' rake test` (make sure they pass)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
