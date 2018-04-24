##  [6.1.6] -
###Added
- Experiments Ids on options
- Option to obfuscateIp
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
