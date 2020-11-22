# Gamesdb
A Ruby gem to interact with [TheGamesDB](http://thegamesdb.net) API.

The Legacy API has been shutdown. The gem is now using the new API and you need to [request an API key](https://forums.thegamesdb.net/viewforum.php?f=10) to use it.

[![Build Status](https://api.travis-ci.com/picandocodigo/gamesdb.svg?branch=master)](https://travis-ci.com/picandocodigo/gamesdb)
[![Gem Version](https://badge.fury.io/rb/thegamesdb.svg)](https://badge.fury.io/rb/thegamesdb)
[![Maintainability](https://api.codeclimate.com/v1/badges/2dcf3cdcbe37adcea569/maintainability)](https://codeclimate.com/github/picandocodigo/gamesdb/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2dcf3cdcbe37adcea569/test_coverage)](https://codeclimate.com/github/picandocodigo/gamesdb/test_coverage)

* [Installation and Quick Start](#installation-and-quick-start)
* [Usage](#usage)
* [Development](#development)
* [Contributing](#contributing)


## Installation and Quick Start

This gem requires Ruby version 2.3 or more. Add this line to your application's Gemfile:

    gem 'thegamesdb'

And then run:

    $ bundle install

Or install it in your system with:

    $ gem install thegamesdb

To use this library, you'll need to request an API Key [here](https://forums.thegamesdb.net/viewforum.php?f=10). Once you have an API KEY, you can instantiate a Client:

```ruby
> client = Gamesdb::Client.new('<API_KEY>')
> response = client.platforms
```

## Usage

The full documentation for the API is available [here](API Documentation: https://api.thegamesdb.net/). Here are the endpoints available on the gem:

### Games

- **[/Games/ByGameID](https://api.thegamesdb.net/#/Games/GamesByGameID)**

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

- **[/Games/ByGameName](https://api.thegamesdb.net/#/Games/GamesByGameName)**

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
- **[/Games/ByPlatformID](https://api.thegamesdb.net/#/Games/GamesByPlatformID)**

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

- **[/Games/Images](https://api.thegamesdb.net/#/Games/GamesImages)**

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

- TODO: **[/Games/Updates](https://api.thegamesdb.net/#/Games/GamesUpdates)**

### Platforms

- **[/Platforms](https://api.thegamesdb.net/#/Platforms/Platforms)**

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
- **[/Platforms/ByPlatformID](https://api.thegamesdb.net/#/Platforms/PlatformsByPlatformID)**

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

- TODO: /Platforms/ByPlatformName
- TODO: /Platforms/Images

### Genres

- TODO: /Genres

### Developers

- TODO: /Developers

### Publishers

- TODO: /Publishers

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
