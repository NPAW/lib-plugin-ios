## [6.2.12] - 
###Added
- Added pluginInfo paramter on session start too
- New iPhone models for device info
- Added AppleTV models

## [6.2.11] - 2018 -12-20
###Fixed
- Viewcode timestamp doesn't include "extra" zeros anymore
- Better auto background management

## [6.2.10] - 2018-12-03
###Changed
- Now autoDetectBackground option is set to true by default

## [6.2.9] - 2018-11-25
###Fixed
- An specific event flow was not adding all transforms when sending collected offline events

## [6.2.8] - 2018-11-21
###Fixed
- Since migration to SQLite v2 to support multithreading the local db was not being created

## [6.2.7] - 2018-11-20
###Fixed
- Several retain cycles Infinity related and memory leaks have been fixed

## [6.2.6] - 2018-11-07
###Fix
- Crash on iOS 12 due to thread management on sqlite database access

## [6.2.5] - 2018-10-30
###Improved
- Posible null pointer exceptions when passin nil to some Infinity public methods

## [6.2.4] - 2018-10-29
###Fixed
- Posible crash when getting nil sessionId

## [6.2.3] - 2018-10-09
###Fixed
- Crash when passing nil screenName

## [6.2.2] - 2018-10-03
###Updated
 - Swift version to support 4.2
###Added
- Add response code log

## [6.2.1] - 2018-08-27
###Fixed
- Correct view expiration behaviour

## [6.2.0] - 2018-08-20
###Added
- Support for Infinity

## [6.1.8] - 2018-07-30
###Improved
- Ping log now shows params
###Fix
- Household id getter now is set as nullable


##  [6.1.7] - 2018-05-04
###Added
- HouseholdId parameter

##  [6.1.6] - 2018-04-27
###Added
- Experiments Ids on options
- New parameters: latency, packetLoss, packetSend
- Option to obfuscateIp
- Option to disable seeks on live content
###Fixed
- Log typo

##  [6.1.5] - 2018-03-08
###Added
- Now there are ten extraparams (total twenty)

##  [6.1.4] - 2018-02-20
###Added
- Now is possible to fireError without init or start

##  [6.1.3] - 2018-02-20
###Fixed
- Wrong version number

##  [6.1.2] - 2018-02-20
###Fixed
- Wrong import name

##  [6.1.1] - 2018-02-20
###Improved
- Possible to send post request easly now too

##  [6.1.0] - 2018-01-30
###Added
- Device info to be more on device info displayed in youbora
- Offline mode
- New options added, User Type, Streaming protocol, Ad Extra params

##  [6.0.7] - 2017-12-22
###Added
- New AdError event

##  [6.0.6] - 2017-12-22
###Fixed
- FireFatalError checks

##  [6.0.5] - 2017-12-20
###Added
- AllAdsCompleted callback
- FireFatalError with exception
- Timemark on every request (just for debugging porpuses)
- FireStop on plugin
###Fixed
- AdInit count to ad total duration
- Pings stop when removing adapter
- FireFatalError at plugin level
- Stop not send if there's no init at least
- Playhead was not being send during ads
###Removed
- End and Stop flags

##  [6.0.5-beta] - 2017-11-24
###Added
- Stop after postrolls

##  [6.0.4] - 2017-11-15
###Fixed
- Effective playtime

##  [6.0.3] - 2017-11-14
###Fixed
- Ad count

##  [6.0.2] - 2017-11-07
###Added
- AdInit method
###Fixed
- adStart log string

##  [6.0.1] - 2017-11-03
###Added
- Support for tvos

##  [6.0.0] - 2017-10-04
###Added
- Autobackground detection added
###Fixed
- pauseDuration on /stop and /ping
