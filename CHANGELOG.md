# Changelog

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
