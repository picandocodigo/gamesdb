# Changelog

## 2.0.0

- Refactored code and functionality. The API support is the same as 1.2.0, but the library was refactored in a way you need to instantiate a client with the API KEY to use it.

### New APIs

- `platforms_by_name`
- `games_update`

### Breaking changes:

You now need to instantiate the Gamesdb::Client class passing in the api_key. E.g:

```ruby
> client = Gamesdb::Client.new(ENV['GAMESDB_API_KEY'])


> client = Gamesdb::Client.new('my_api_key')
> client.platforms
...
```

Changes in methods:

- `platform_by_id` changes to `platforms_by_id`.
- `game_by_id` changes to `games_by_id`.
- `game_images` changes to `games_images`.
These APIs now support a string of comma delimited ids as parameters as well as the id Integer.


## 1.2.0
- Raise ArgumentError if api key isn't present

## 1.1.2
* Internal changes: update API endpoint url (adds `v1`), update tests

## 1.1.1
* Adds `platform_id` parameter to `games_by_name`
* Adds `page` parameter to `games_by_name`
* Adds extra fields and boxart to `games_by_name` response
* Refactors `process_platform_games`

## 1.1.0
* Adds `page` parameter to `games_by_platform_id` and includes `boxart`.
* Adds all available fields from Platforms in `platforms`, updates tests. Changes `:slug` to `:alias` in platforms response, to map to same response from API.
* Refactored `json_response` to use `includes` and extra data from the API response.

## 1.0.0

* Updated to new API endpoint, API key is now required to use the gem. Request an API Key here: https://forums.thegamesdb.net/viewforum.php?f=10
* Legacy API no longer supported since it's been shutdown.
* Since the API has changed, some endpoints are no longer supported and some new ones are supported.
* Removed ox dependency, the new returns JSON instead of XML.

## 0.2.0

* The API endpoint has been updated, so this release updates the API endpoint to the legacy.
* Updates the way the incoming XML is parsed, so more fields are available from the raw API response. It's also easier to parse using a different method from `ox` than before.
* No longer supports Ruby 2.2, it's out of support life.

## Previous versions

Implements GetGamesList, GetGame, GetArt, GetPlatformsList, GetPlatform, GetPlatformGames, PlatformGames from the original API.
