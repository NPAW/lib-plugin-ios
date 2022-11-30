## [6.6.26] - 2022-11-30
### Added
- New iPad and iPad Pro device models
- AppleTV device models

## [6.6.25] - 2022-10-31
### Added
- Support to send requests with POST method and parameters on the request body

## [6.6.24] - 2022-09-27
### Fixed
- iOS 16 request non string exception in `getUrl` method

## [6.6.23] - 2022-09-16
### Added
- New iPhone 14 device models

## [6.6.22] - 2022-07-26
### Fixed
- Device info duplicates models

## [6.6.21] - 2022-07-19
### Added
- New iPhone and iPad models for device info

## [6.6.20] - 2022-07-08
### Added
- `userPrivacyProtocol` option

## [6.6.19] - 2022-06-28
### Added
- `fireAdBreakStart` and `fireAdManifest` calls to adInit parameters

### Changed
- stop to be fired only once

## [6.6.18] - 2022-06-07
### Added
- `parseManifestAuth` option

## [6.6.17] - 2022-05-10
### Fixed
- `parseCdnNameHeader` and `parseCdnNodeHeader` getters in `YBResourceTransform`

## [6.6.16] - 2022-04-29
### Added
- `parseCdnNodeHeader` option to parse from additional requests the host name providing content when using a custom balancer

### Fixed
- `parsedResource` param requests after `ResourceTransform` is done.

## [6.6.15] - 2022-04-12
### Fixed
- `adStop` and `adBreakStop` fired when content is changed during pre-rolls
- Availability to fire stop without view initialization condition

## [6.6.14] - 2022-04-12
### Fixed
- `live` parameter in start request

## [6.6.13] - 2022-03-23
### Added
- `contentLanguage` to ping request

## [6.6.12] - 2022-03-11
### Added
- `householdId` in `YBOptionKeys`

### Fixed
- `deviceOsName` typo

## [6.6.11] - 2022-03-03
### Added
- `contentPackage` option

## [6.6.10] - 2022-02-04
### Added
- `pause` and `resume` functions to `YBChrono`
- New `authToken` and `authType` options

## [6.6.9] - 2022-02-01
### Fixed
- Availability for using YouboraLib with no `use_frameworks!` on Podfile

## [6.6.8] - 2022-01-10
### Added
- NosOtt cdn parse

### Fixed
- Parsed resource logic

### Removed
- `contentPackage` option

## [6.6.7] - 2021-12-07
### Added
- Duration of the content can be reported if the content is live if it is set as an option, using `contentDuration`
- Added `adNumberInBreak` parameter in ad events

## [6.6.6] - 2021-11-11
### Changed
- Input type of `device.EDID` option

### Fixed
- Verification of not nil `contentIsLiveNoMonitor` value

## [6.6.5] - 2021-11-02
### Added
- New `device.EDID` option
- New iPhone models for device info

## [6.6.4] - 2021-10-26
### Fixed
- Request condition for parse manifest requests

### Changed
- Options' naming to match with js plugin

## [6.6.3] - 2021-10-04
### Added
- Player name parameter on adError event
- `firePause` and `fireResume` when ads start and end
- `URL` obtained directly from the player in `getURLToParse` reported as `parsedResource` if there is no response from the manifest parser feature or is disabled

## [6.6.2] - 2021-09-23
### Added
- New `adBlockerDetected` option and functionality

## [6.6.1] - 2021-09-13
### Added
- Edgecast cdn parse

## [6.6.0] - 2021-08-20
### Added
- New `contentIsLiveNoMonitor` option and functionality
- New `contentCustomDimensions` option, as an alternative way to use custom dimensions like `contentCustomDimension1`

## [6.5.49] - 2021-08-04
### Added
- Additional case for `parseResource` when manifest is redirected and can't access to Location header

## [6.5.48] - 2021-08-03
### Fixed
- Ad breaks parsing when calculating if should close view in a post-roll ad

## [6.5.47] - 2021-07-15
### Fixed
- AdBufferUnderrun called when buffer ends instead of when buffer begins

## [6.5.46] - 2021-06-30
### Added
- Parser for hls manifests with multiple variables instead of only an url
- `ObfuscateIP` parameter reported on session start
- Case insensitive for akamai cdn type parser
- Test for akamai cdn parse when using head instead of get request

## [6.5.45] - 2021-06-07
### Fixed
-  Parse cdn for akamai now uses head instead of get request
- adStop method with post-roll ads

## [6.5.44] - 2021-06-02
### Fixed
-  'adViewability' and 'adViewedDuration' methods

### Added
-  Method to handle fire stop when there are post-roll ads

## [6.5.43] - 2021-05-27
### Fixed
-  Options to define fatal, non fatal and ignore errors 

## [6.5.42] - 2021-05-17
### Added
-  'adViewability' and 'adViewedDuration' to adStop request

## [6.5.41] - 2021-05-14
### Added
- New dimension for ads that defines its type of ad insertion

### Changed
- Nil values of 'playhead' and 'mediaDuration' when content is live

## [6.5.40] - 2021-05-06
### Changed
-  'adViewability' and 'adViewedDuration' to milliseconds

## [6.5.39] - 2021-04-07
### Added
-  'breakNumber' to ad requests

## [6.5.38] - 2021-03-24
### Added
-  .cmfv transform format

## [6.5.37] - 2021-03-09
### Added
- Metrics on stop
- Session metrics on session stop

## [6.5.36] - 2021-02-12
### Added
- Parameter 'linkedViewId' in fireStart
- Parameter 'topLevelDimensions' in fireEvent

## [6.5.35] - 2021-01-07
### Added
- Parameters included in sessionstart

## [6.5.34] - 2020-11-26
### Added
- Option to send a custom device UUID

## [6.5.33] - 2020-11-16
### Added
- Options to define fatal, nonFatal and ignore errors

## [6.5.32] - 2020-10-26
### Fixed
- Move rendition from init to start

### Changed
- Send latency only when is live video

## [6.5.31] - 2020-09-14
### Added
- Send YBFastDataConfig via constructor

## [6.5.30] - 2020-08-18
### Added
- Parse to search by new CDN changes

## [6.5.29] - 2020-08-17
### Added
- Playhead in the erros params

### Changed
- Change presistence data to Swift

### Fixed
- Fix problem with hls parser when the manifest is pointing to the host
- Fix diffTime to fit with pingTime
- Public headers

## [6.5.28] - 2020-06-30
### Added
- Get url to be parsed as a resource by the plugin

## [6.5.27] - 2020-06-08
### Added
- The subtitles option to entities in pings

### Fixed
- FastData was not being called on session stop

## [6.5.26] - 2020-06-02
### Fixed
- Issue with diff time in session beat after a session nav

## [6.5.25] - 2020-05-26
### Fixed
- Don't allow the plugin to send the same error in less than 5 secs 
- Don't parse cdn case cdn is disabled
- Wrong cast done in YBRequest on iOS 13.4 and higher

## [6.5.24] - 2020-05-18
### Added
- Transport format
- Auto detection case transport format or streaming protocol not defined

### Changed
- Streaming protocol only accepts YBConstantsStreamProtocol values

### Fixed
- Memory leaks caused by unreleased delegates 
- Warning caused by code indentation and nullability conditions

## [6.5.23] - 2020-05-06
### Added
- Method to stop the plugin when no more plugin is needed

### Fixed
- Stop Ad and video when it goes to background

## [6.5.22] - 2020-05-05
### Fixed
- creation of a new session after 4 minutes in background 

## [6.5.21] - 2020-04-28
### Added
- Auto init before and send an error

### Fixed
- parentId to match with sessionRoot

## [6.5.20] - 2020-04-27
### Fixed
- Fix services comparation to send sessionId
- Check condition to send parentId

### Deprecated
- isInfinity options flag 

## [6.5.19] - 2020-04-22
### Added
- ParentId on start, init and error requests
- Track total downloaded bytes 

### Fixed
- Fix metrics format

## [6.5.18] - 2020-04-06
### Added
- YBOptionUtilsKeys to easly share new props with config utils

### Changed
- Replace adPosition & breakPosition for position on requests
- Unify resource parsers into one option
- Move request parameters to the constants properties
- YBOption properties to YBOptionKeys class 

### Deprecated
- Old parsers, since now they represent only one parser 
- Old props in the YBOptions class

## [6.5.17] - 2020-02-06
### Changed
- macOS deployment target to 10.10

## [6.5.16] - 2020-02-03
### Added
- Support to send audio and video codecs by the adapters

## [6.5.15] - 2020-01-29
### Added
- Add classes (YBTimer, YBUtils, YBDeviceInfo, YBConstants and YBChrono) to swift

### Removed
- Add classes (YBTimer, YBUtils, YBDeviceInfo, YBConstants and YBChrono) to Obj-c

## [6.5.14] - 2020-01-27
### Fixed
- Infinity sends propper codes for all cases now

## [6.5.13] - 2019-12-04
### Added
- Send p2pEnabled property to init and start events

## [6.5.12] - 2019-12-04
### Fixed
- Fix issues with CFBundleShortVersionString

## [6.5.11] - 2019-12-04
### Added
- Support to the new xcframeworks (module stability)
- Option to parse dash resources

### Fixed
- There as an issue with NSDictionary types for some options 

## [6.5.10] - 2019-11-26
### Added
- Add SwiftLog class

### Fixed
- Fix crash on adapter's fireEvent

## [6.5.9] - 2019-11-14
### Fixed
- Offline events view code was not properly set when using timestamps

## [6.5.8] - 2019-10-23
### Added
- Add support for swift from 4.0 to 5.1
- Add support for xCode compilers from 9.2 to 11

### Fixed
- Remove getResource semicolon

## [6.5.7] - 2019-10-09
### Fixed
- Fix streaming protocol option

## [6.5.6] - 2019-10-02
### Added
- Add parsedResource parameter

### Improved
- Wait for metadata now is not attached to ping timer

## [6.5.5] - 2019-09-19
### Misc
- Dummy commit to trigger travis deploy stage

## [6.5.4] - 2019-09-04
### Fixed
- ContentPlayerbackType was being ignored if setting isLive option to any non nil value

## [6.5.3] - 2019-07-24
### Fixed
- Fix Infinity background
- Metadata check when not having an ad adapter

## [6.5.2] - 2019-07-17
### Added
- Bump version

## [6.5.1] - 2019-07-17
### Added
- Break stop request when going to background

### Replaced
- Now deviceUUID is used instead of Fingerprint

## [6.5.0] - 2019-05-26
### Added
- New ad events ad manifest, break start, break stop and ad quartile
- New parameters on the ads (givenAds, expectedAds, givenBreaks, expectedBreaks, breakNumber)

## [6.4.10] - 2019-05-26
### Added
- All extraparams are sent on session start request as well

### Fixed
- Different threads were accessing the same array to make RW operations and in some cases the index may not exist anymore, now this is prevented locking the array between operations

## [6.4.9] - 2019-05-29
### Added
- Mac OS support

## [6.4.8] - 2019-05-22
### Added
- Video events

## [6.4.7] - 2019-05-08
### Changed
- Fastdata url now points to a-fds.youborafds01.com

## [6.4.6] - 2019-04-24
### Added
- New content options have been added

## [6.4.5] - 2019-04-16
### Improved
- Now any Infinity request won't have code, sessionId will be used instead

## [6.4.4] - 2019-04-16
### Fixed
- Macro for SWIFT_VERSION now is set to 5.0

## [6.4.3] - 2019-04-15
### Added
- Now the parsing of Location header is supported

### Updated
- Update to Swift 5

## [6.4.2] - 2019-04-09
### Fix
- Optional Swift vars and params, set as nullable in Objective-C.

## [6.4.1] - 2019-04-02
### Add
- Renaming for customDimensions

## [6.4.0] - 2019-04-02
### Added
- Now is possible to delay the start event (and therefore have all the metadata ready) and have correcto joinTime

## [6.3.10] - 2019-03-13
### Ported
- YBChrono has been ported to Swift

## [6.3.9] - 2019-03-07
### Fixed
- Plugin now stops in case of error between /init and /start

## [6.3.8] - 2019-03-06
### Fixed
- Plus sign '+' is now sent correctly on any given parameter of the url

## [6.3.7] - 2019-02-20
### Added
- sessionRoot parameter is back for ALL requests

## [6.3.6] - 2019-02-18
### Fixed
- If using extraparamN they were not sent, now they are

## [6.3.5] - 2019-02-13
### Added
- Fingerprint parameter
- Account code on all requests
- AdError is sent if happens before init or start

### Fixed
- AKAMAI cdn parse should work as expected right now

### Improved
- Infinity url parameters are not send anymore if false

### Removed
- NQS6 transform

## [6.3.4] - 2019-02-06
### Added
- Auto ad Init
- Telefonica CDN
- New getProgram method
- New customDimensions method for content and ads
- App name and App release version options

### Fixed
- Correct time between retries

### Deprecated
- getTitle2
- Extra params

## [6.3.3] - 2019-01-24
### Fixed
- Improved support for carthage as a build and dependency system

## [6.3.2] - 2019-01-24
### Fixed
- In certain cases comm was reinstantiated and no event where send afterwards

## [6.3.1] - 2019-01-23
### Added
- Deprecate all ads completed method

### Fixed
- Playhead monitor with different playrate than 0 or 1

## [6.3.0] - 2019-01-21
### Added
- Automatic init

## [6.2.13] - 2018-01-16
### Fixed
- Apple TV now is named AppleTV 4G

## [6.2.12] - 2018-01-14
### Added
- Added pluginInfo paramter on session start too
- New iPhone models for device info
- Added AppleTV models

## [6.2.11] - 2018 -12-20
### Fixed
- Viewcode timestamp doesn't include "extra" zeros anymore
- Better auto background management

## [6.2.10] - 2018-12-03
### Changed
- Now autoDetectBackground option is set to true by default

## [6.2.9] - 2018-11-25
### Fixed
- An specific event flow was not adding all transforms when sending collected offline events

## [6.2.8] - 2018-11-21
### Fixed
- Since migration to SQLite v2 to support multithreading the local db was not being created

## [6.2.7] - 2018-11-20
### Fixed
- Several retain cycles Infinity related and memory leaks have been fixed

## [6.2.6] - 2018-11-07
### Fix
- Crash on iOS 12 due to thread management on sqlite database access

## [6.2.5] - 2018-10-30
### Improved
- Posible null pointer exceptions when passin nil to some Infinity public methods

## [6.2.4] - 2018-10-29
### Fixed
- Posible crash when getting nil sessionId

## [6.2.3] - 2018-10-09
### Fixed
- Crash when passing nil screenName

## [6.2.2] - 2018-10-03
### Updated
- Swift version to support 4.2

### Added
- Add response code log

## [6.2.1] - 2018-08-27
### Fixed
- Correct view expiration behaviour

## [6.2.0] - 2018-08-20
### Added
- Support for Infinity

## [6.1.8] - 2018-07-30
### Improved
- Ping log now shows params

### Fix
- Household id getter now is set as nullable

## [6.1.7] - 2018-05-04
### Added
- HouseholdId parameter

## [6.1.6] - 2018-04-27
### Added
- Experiments Ids on options
- New parameters: latency, packetLoss, packetSend
- Option to obfuscateIp
- Option to disable seeks on live content

### Fixed
- Log typo

## [6.1.5] - 2018-03-08
### Added
- Now there are ten extraparams (total twenty)

## [6.1.4] - 2018-02-20
### Added
- Now is possible to fireError without init or start

## [6.1.3] - 2018-02-20
### Fixed
- Wrong version number

## [6.1.2] - 2018-02-20
### Fixed
- Wrong import name

## [6.1.1] - 2018-02-20
### Improved
- Possible to send post request easly now too

## [6.1.0] - 2018-01-30
### Added
- Device info to be more on device info displayed in youbora
- Offline mode
- New options added, User Type, Streaming protocol, Ad Extra params

## [6.0.7] - 2017-12-22
### Added
- New AdError event

## [6.0.6] - 2017-12-22
### Fixed
- FireFatalError checks

## [6.0.5] - 2017-12-20
### Added
- AllAdsCompleted callback
- FireFatalError with exception
- Timemark on every request (just for debugging porpuses)
- FireStop on plugin

### Fixed
- AdInit count to ad total duration
- Pings stop when removing adapter
- FireFatalError at plugin level
- Stop not send if there's no init at least
- Playhead was not being send during ads

### Removed
- End and Stop flags

## [6.0.5-beta] - 2017-11-24
### Added
- Stop after postrolls

## [6.0.4] - 2017-11-15
### Fixed
- Effective playtime

## [6.0.3] - 2017-11-14
### Fixed
- Ad count

## [6.0.2] - 2017-11-07
### Added
- AdInit method

### Fixed
- adStart log string

## [6.0.1] - 2017-11-03
### Added
- Support for tvos

## [6.0.0] - 2017-10-04
### Added
- Autobackground detection added

### Fixed
- pauseDuration on /stop and /ping
