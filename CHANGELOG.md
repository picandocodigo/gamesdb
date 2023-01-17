# Changelog

## 2.1.0

Now testing Ruby versions 3.0, 3.1, 3.2, JRuby and TruffleRuby.

- Added some better error handling. Now you can catch from `Gamesdb::Error` if there's any response from the server with status >= 300 (e.g. 403 for wrong API Key). I'll improve on this in future releases.
- Refactored main client class and extracted utilitary functions into `Gamesdb::Utils`.

## 2.0.0

Refactored code and functionality. The library was refactored in a way you need to instantiate a client with the API key to use it (more info in "Breaking changes"). 100% of the documented API is now supported and implemented.

The base API Response includes the `remaining_monthly_allowance` for your API key, `extra_allowance` and `allowance_refresh_timer`. These values are updated on the client instance on every request so you can use `client.remaining_monthly_client` to check how many requests the API key has left.

### New APIs

- `developers`
- `games_update`
- `genres`
- `platforms_by_name`
- `platforms_images`
- `publishers`


### Breaking changes:

- Dropped support for Ruby 2.4. The gem might still work on Ruby 2.4, but it's not being regularly tested for any version lower than 2.5.

- You now need to instantiate the Gamesdb::Client class passing in the api_key. E.g:

```ruby
> client = Gamesdb::Client.new(ENV['GAMESDB_API_KEY'])


> client = Gamesdb::Client.new('my_api_key')
> client.platforms
...
```

- Changes in methods:

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
