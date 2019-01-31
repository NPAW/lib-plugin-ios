//
//  YBConstants.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBConstants.h"

NSString * const YouboraServiceData = @"/data";
NSString * const YouboraServiceInit = @"/init";
NSString * const YouboraServiceStart = @"/start";
NSString * const YouboraServiceJoin = @"/joinTime";
NSString * const YouboraServicePause = @"/pause";
NSString * const YouboraServiceResume = @"/resume";
NSString * const YouboraServiceSeek = @"/seek";
NSString * const YouboraServiceBuffer = @"/bufferUnderrun";
NSString * const YouboraServiceError = @"/error";
NSString * const YouboraServiceStop = @"/stop";
NSString * const YouboraServicePing = @"/ping";
NSString * const YouboraServiceOffline = @"/offlineEvents";
NSString * const YouboraServiceAdInit = @"/adInit";
NSString * const YouboraServiceAdStart = @"/adStart";
NSString * const YouboraServiceAdJoin = @"/adJoin";
NSString * const YouboraServiceAdPause = @"/adPause";
NSString * const YouboraServiceAdResume = @"/adResume";
NSString * const YouboraServiceAdBuffer = @"/adBufferUnderrun";
NSString * const YouboraServiceAdStop = @"/adStop";
NSString * const YouboraServiceClick = @"/adClick";
NSString * const YouboraServiceAdError = @"/adError";

/** Infinity **/
NSString * const YouboraServiceSessionStart = @"/infinity/session/start";
NSString * const YouboraServiceSessionStop = @"/infinity/session/stop";
NSString * const YouboraServiceSessionNav = @"/infinity/session/nav";
NSString * const YouboraServiceSessionEvent = @"/infinity/session/event";
NSString * const YouboraServiceSessionBeat = @"/infinity/session/beat";

//Request success constants
NSString * const YouboraSuccsessListenerOfflineId = @"offline_id";

#define MACRO_NAME(f) #f
#define MACRO_VALUE(f)  MACRO_NAME(f)

#ifdef YOUBORALIB_VERSION
NSString * const YouboraLibVersion = @MACRO_VALUE(YOUBORALIB_VERSION);
#endif
