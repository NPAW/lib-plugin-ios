//
//  YBConstants.h
//  YouboraLib
//
//  Created by Tiago Pereira on 16/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBConstantsRequest : NSObject
+(NSString*)accountCode;
+(NSString*)username;
+(NSString*)rendition;
+(NSString*)title;
+(NSString*)title2;
+(NSString*)live;
+(NSString*)mediaDuration;
+(NSString*)mediaResource;
+(NSString*)parsedResource;
+(NSString*)transactionCode;
+(NSString*)properties;
+(NSString*)cdn;
+(NSString*)playerVersion;
+(NSString*)param1;
+(NSString*)param2;
+(NSString*)param3;
+(NSString*)param4;
+(NSString*)param5;
+(NSString*)param6;
+(NSString*)param7;
+(NSString*)param8;
+(NSString*)param9;
+(NSString*)param10;
+(NSString*)param11;
+(NSString*)param12;
+(NSString*)param13;
+(NSString*)param14;
+(NSString*)param15;
+(NSString*)param16;
+(NSString*)param17;
+(NSString*)param18;
+(NSString*)param19;
+(NSString*)param20;
+(NSString*)pluginVersion;
+(NSString*)pluginInfo;
+(NSString*)isp;
+(NSString*)connectionType;
+(NSString*)ip;
+(NSString*)deviceCode;
+(NSString*)preloadDuration;
+(NSString*)player;
+(NSString*)deviceInfo;
+(NSString*)userType;
+(NSString*)streamingProtocol;
+(NSString*)transportFormat;
+(NSString*)experiments;
+(NSString*)obfuscateIp;
+(NSString*)householdId;
+(NSString*)navContext;
+(NSString*)anonymousUser;
+(NSString*)smartswitchConfigCode;
+(NSString*)smartswitchGroupCode;
+(NSString*)smartswitchContractCode;
+(NSString*)nodeHost;
+(NSString*)nodeType;
+(NSString*)appName;
+(NSString*)appReleaseVersion;
+(NSString*)email;
+(NSString*)package;
+(NSString*)saga;
+(NSString*)tvshow;
+(NSString*)season;
+(NSString*)titleEpisode;
+(NSString*)channel;
+(NSString*)contentId;
+(NSString*)imdbID;
+(NSString*)gracenoteID;
+(NSString*)contentType;
+(NSString*)genre;
+(NSString*)contentLanguage;
+(NSString*)subtitles;
+(NSString*)contractedResolution;
+(NSString*)cost;
+(NSString*)price;
+(NSString*)playbackType;
+(NSString*)drm;
+(NSString*)videoCodec;
+(NSString*)audioCodec;
+(NSString*)codecSettings;
+(NSString*)codecProfile;
+(NSString*)containerFormat;
+(NSString*)adsExpected;
+(NSString*)deviceUUID;
+(NSString*)p2pEnabled;
+(NSString*)adTitle;
+(NSString*)playhead;
+(NSString*)position;
+(NSString*)adDuration;
+(NSString*)adResource;
+(NSString*)adCampaign;
+(NSString*)adPlayerVersion;
+(NSString*)adProperties;
+(NSString*)adAdapterVersion;
+(NSString*)extraparam1;
+(NSString*)extraparam2;
+(NSString*)extraparam3;
+(NSString*)extraparam4;
+(NSString*)extraparam5;
+(NSString*)extraparam6;
+(NSString*)extraparam7;
+(NSString*)extraparam8;
+(NSString*)extraparam9;
+(NSString*)extraparam10;
+(NSString*)skippable;
+(NSString*)breakNumber;
+(NSString*)adCreativeId;
+(NSString*)adProvider;
+(NSString*)system;
+(NSString*)isInfinity;
+(NSString*)pauseDuration;
+(NSString*)joinDuration;
+(NSString*)seekDuration;
+(NSString*)bufferDuration;
+(NSString*)bitrate;
+(NSString*)adJoinDuration;
+(NSString*)adPlayhead;
+(NSString*)adPauseDuration;
+(NSString*)adBitrate;
+(NSString*)adTotalDuration;
+(NSString*)adUrl;
+(NSString*)givenBreaks;
+(NSString*)expectedBreaks;
+(NSString*)expectedPattern;
+(NSString*)breaksTime;
+(NSString*)givenAds;
+(NSString*)expectedAds;
+(NSString*)adViewedDuration;
+(NSString*)adViewability;
+(NSString*)droppedFrames;
+(NSString*)playrate;
+(NSString*)latency;
+(NSString*)packetLoss;
+(NSString*)packetSent;
+(NSString*)metrics;
+(NSString*)language;
+(NSString*)sessionMetrics;
+(NSString*)nodeTypeString;
+(NSString*)adNumber;
+(NSString*)fps;
+(NSString*)throughput;
+(NSString*)p2pDownloadedTraffic;
+(NSString*)cdnDownloadedTraffic;
+(NSString*)sessions;
+(NSString*)uploadTraffic;
+(NSString*)adBufferDuration;
+(NSString*)parentId;
+(NSString*)totalBytes;
@end

@interface YBConstantsStreamProtocol: NSObject
+(NSString*)hds;
+(NSString*)hls;
+(NSString*)mss;
+(NSString*)dash;
+(NSString*)rtmp;
+(NSString*)rtp;
+(NSString*)rtsp;
@end

// YBConstants with transport format
@interface YBConstantsTransportFormat: NSObject
+(NSString*)hlsTs;
+(NSString*)hlsFmp4;
@end

// Service YBConstants
@interface YBConstantsYouboraService: NSObject
/** /data service */
+(NSString*)data;
/** /init service */
+(NSString*)sInit;
/** /start service */
+(NSString*)start;
/** /joinTime service */
+(NSString*)join;
/** /pause service */
+(NSString*)pause;
/** /resume service */
+(NSString*)resume;
/** /seek service */
+(NSString*)seek;
/** /bufferUnderrun service */
+(NSString*)buffer;
/** /error service */
+(NSString*)error;
/** /stop service */
+(NSString*)stop;
/** /ping service */
+(NSString*)ping;
/** /offlineEvents */
+(NSString*)offline;
/** /adInit service */
+(NSString*)adInit;
/** /adStart service */
+(NSString*)adStart;
/** /adJoin service */
+(NSString*)adJoin;
/** /adPause service */
+(NSString*)adPause;
/** /adResume service */
+(NSString*)adResume;
/** /adBufferUnderrun service */
+(NSString*)adBuffer;
/** /adStop service */
+(NSString*)adStop;
/** /adClick service */
+(NSString*)click;
/** /adError service */
+(NSString*)adError;
/** /adManifest service */
+(NSString*)adManifest;
/** /adBreakStart service */
+(NSString*)adBreakStart;
/** /adBreakStop service */
+(NSString*)adBreakStop;
/** /adQuartile service */
+(NSString*)adQuartile;
@end

// Infinity service YBConstants
@interface YBConstantsYouboraInfinity: NSObject
/** /infinity/session/start service **/
+(NSString*)sessionStart;
/** /infinity/session/stop service **/
+(NSString*)sessionStop;
/** /infinity/session/nav service **/
+(NSString*)sessionNav;
/** /infinity/session/event service **/
+(NSString*)sessionEvent;
/** /infinity/session/beat service **/
+(NSString*)sessionBeat;
/** /infinity/video/event service **/
+(NSString*)videoEvent;
@end

// Infinity service YBConstants
@interface YBConstantsErrorParams: NSObject
/** Key to save code in error parameters **/
+(NSString*)code;
/** Key to save message in error parameters **/
+(NSString*)message;
/** Key to save metadata in error parameters **/
+(NSString*)metadata;
/** Key to save the level in error parameters **/
+(NSString*)level;
@end
