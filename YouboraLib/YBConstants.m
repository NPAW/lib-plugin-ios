//
//  YBConstants.m
//  YouboraLib
//
//  Created by Tiago Pereira on 16/07/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBConstants.h"

NSString *const YB_REQUEST_ACCOUNT_CODE = @"accountCode";
NSString *const YB_REQUEST_USERNAME = @"username";
NSString *const YB_REQUEST_RENDITION = @"rendition";
NSString *const YB_REQUEST_TITLE = @"title";
NSString *const YB_REQUEST_TITLE2 = @"title2";
NSString *const YB_REQUEST_LIVE = @"live";
NSString *const YB_REQUEST_MEDIA_DURATION = @"mediaDuration";
NSString *const YB_REQUEST_MEDIA_RESOURCE = @"mediaResource";
NSString *const YB_REQUEST_PARSED_RESOURCE = @"parsedResource";
NSString *const YB_REQUEST_TRANSACTION_CODE = @"transactionCode";
NSString *const YB_REQUEST_PROPERTIES = @"properties";
NSString *const YB_REQUEST_CDN = @"cdn";
NSString *const YB_REQUEST_PLAYER_VERSION = @"playerVersion";
NSString *const YB_REQUEST_PARAM_1 = @"param1";
NSString *const YB_REQUEST_PARAM_2 = @"param2";
NSString *const YB_REQUEST_PARAM_3 = @"param3";
NSString *const YB_REQUEST_PARAM_4 = @"param4";
NSString *const YB_REQUEST_PARAM_5 = @"param5";
NSString *const YB_REQUEST_PARAM_6 = @"param6";
NSString *const YB_REQUEST_PARAM_7 = @"param7";
NSString *const YB_REQUEST_PARAM_8 = @"param8";
NSString *const YB_REQUEST_PARAM_9 = @"param9";
NSString *const YB_REQUEST_PARAM_10 = @"param10";
NSString *const YB_REQUEST_PARAM_11 = @"param11";
NSString *const YB_REQUEST_PARAM_12 = @"param12";
NSString *const YB_REQUEST_PARAM_13 = @"param13";
NSString *const YB_REQUEST_PARAM_14 = @"param14";
NSString *const YB_REQUEST_PARAM_15 = @"param15";
NSString *const YB_REQUEST_PARAM_16 = @"param16";
NSString *const YB_REQUEST_PARAM_17 = @"param17";
NSString *const YB_REQUEST_PARAM_18 = @"param18";
NSString *const YB_REQUEST_PARAM_19 = @"param19";
NSString *const YB_REQUEST_PARAM_20 = @"param20";
NSString *const YB_REQUEST_PLUGIN_VERSION = @"pluginVersion";
NSString *const YB_REQUEST_PLUGIN_INFO = @"pluginInfo";
NSString *const YB_REQUEST_ISP = @"isp";
NSString *const YB_REQUEST_CONNECTION_TYPE = @"connectionType";
NSString *const YB_REQUEST_IP = @"ip";
NSString *const YB_REQUEST_DEVICE_CODE = @"deviceCode";
NSString *const YB_REQUEST_PRELOAD_DURATION = @"preloadDuration";
NSString *const YB_REQUEST_PLAYER = @"player";
NSString *const YB_REQUEST_DEVICE_INFO = @"deviceInfo";
NSString *const YB_REQUEST_USER_TYPE = @"userType";
NSString *const YB_REQUEST_STREAMING_PROTOCOL = @"streamingProtocol";
NSString *const YB_REQUEST_TRANSPORT_FORMAT = @"transportFormat";
NSString *const YB_REQUEST_EXPERIMENTS = @"experiments";
NSString *const YB_REQUEST_OBFUSCATE_IP = @"obfuscateIp";
NSString *const YB_REQUEST_HOUSEHOLD_ID = @"householdId";
NSString *const YB_REQUEST_NAV_CONTEXT = @"navContext";
NSString *const YB_REQUEST_ANONYMOUS_USER = @"anonymousUser";
NSString *const YB_REQUEST_EXTRA_PARAM1 = @"extraparam1";
NSString *const YB_REQUEST_EXTRA_PARAM2 = @"extraparam2";
NSString *const YB_REQUEST_EXTRA_PARAM3 = @"extraparam3";
NSString *const YB_REQUEST_EXTRA_PARAM4 = @"extraparam4";
NSString *const YB_REQUEST_EXTRA_PARAM5 = @"extraparam5";
NSString *const YB_REQUEST_EXTRA_PARAM6 = @"extraparam6";
NSString *const YB_REQUEST_EXTRA_PARAM7 = @"extraparam7";
NSString *const YB_REQUEST_EXTRA_PARAM8 = @"extraparam8";
NSString *const YB_REQUEST_EXTRA_PARAM9 = @"extraparam9";
NSString *const YB_REQUEST_EXTRA_PARAM10 = @"extraparam10";

//@implementation YBConstantsRequest
//+(NSString*)smartswitchConfigCode { return @"smartswitchConfigCode";}
//+(NSString*)smartswitchGroupCode { return @"smartswitchGroupCode";}
//+(NSString*)smartswitchContractCode { return @"smartswitchContractCode";}
//+(NSString*)nodeHost { return @"nodeHost";}
//+(NSString*)nodeType { return @"nodeType";}
//+(NSString*)appName { return @"appName";}
//+(NSString*)appReleaseVersion { return @"appReleaseVersion";}
//+(NSString*)email { return @"email";}
//+(NSString*)package { return @"package";}
//+(NSString*)saga { return @"saga";}
//+(NSString*)tvshow { return @"tvshow";}
//+(NSString*)season { return @"season";}
//+(NSString*)titleEpisode { return @"titleEpisode";}
//+(NSString*)channel { return @"channel";}
//+(NSString*)contentId { return @"contentId";}
//+(NSString*)imdbID { return @"imdbID";}
//+(NSString*)gracenoteID { return @"gracenoteID";}
//+(NSString*)contentType { return @"contentType";}
//+(NSString*)genre { return @"genre";}
//+(NSString*)contentLanguage { return @"contentLanguage";}
//+(NSString*)subtitles { return @"subtitles";}
//+(NSString*)contractedResolution { return @"contractedResolution";}
//+(NSString*)cost { return @"cost";}
//+(NSString*)price { return @"price";}
//+(NSString*)playbackType { return @"playbackType";}
//+(NSString*)drm { return @"drm";}
//+(NSString*)videoCodec { return @"videoCodec";}
//+(NSString*)audioCodec { return @"audioCodec";}
//+(NSString*)codecSettings { return @"codecSettings";}
//+(NSString*)codecProfile { return @"codecProfile";}
//+(NSString*)containerFormat { return @"containerFormat";}
//+(NSString*)adsExpected { return @"adsExpected";}
//+(NSString*)deviceUUID { return @"deviceUUID";}
//+(NSString*)p2pEnabled { return @"p2pEnabled";}
//+(NSString*)adTitle { return @"adTitle";}
//+(NSString*)playhead { return @"playhead";}
//+(NSString*)position { return @"position";}
//+(NSString*)adDuration { return @"adDuration";}
//+(NSString*)adResource { return @"adResource";}
//+(NSString*)adCampaign { return @"adCampaign";}
//+(NSString*)adPlayerVersion { return @"adPlayerVersion";}
//+(NSString*)adProperties { return @"adProperties";}
//+(NSString*)adAdapterVersion { return @"adAdapterVersion";}
//+(NSString*)skippable { return @"skippable";}
//+(NSString*)breakNumber { return @"breakNumber";}
//+(NSString*)adCreativeId { return @"adCreativeId";}
//+(NSString*)adProvider { return @"adProvider";}
//+(NSString*)system { return @"system";}
//+(NSString*)isInfinity { return @"isInfinity";}
//+(NSString*)pauseDuration { return @"pauseDuration";}
//+(NSString*)joinDuration { return @"joinDuration";}
//+(NSString*)seekDuration { return @"seekDuration";}
//+(NSString*)bufferDuration { return @"bufferDuration";}
//+(NSString*)bitrate { return @"bitrate";}
//+(NSString*)adJoinDuration { return @"adJoinDuration";}
//+(NSString*)adPlayhead { return @"adPlayhead";}
//+(NSString*)adPauseDuration { return @"adPauseDuration";}
//+(NSString*)adBitrate { return @"adBitrate";}
//+(NSString*)adTotalDuration { return @"adTotalDuration";}
//+(NSString*)adUrl { return @"adUrl";}
//+(NSString*)givenBreaks { return @"givenBreaks";}
//+(NSString*)expectedBreaks { return @"expectedBreaks";}
//+(NSString*)expectedPattern { return @"expectedPattern";}
//+(NSString*)breaksTime { return @"breaksTime";}
//+(NSString*)givenAds { return @"givenAds";}
//+(NSString*)expectedAds { return @"expectedAds";}
//+(NSString*)adViewedDuration { return @"adViewedDuration";}
//+(NSString*)adViewability { return @"adViewability";}
//+(NSString*)droppedFrames { return @"droppedFrames";}
//+(NSString*)playrate { return @"playrate";}
//+(NSString*)latency { return @"latency";}
//+(NSString*)packetLoss { return @"packetLoss";}
//+(NSString*)packetSent { return @"packetSent";}
//+(NSString*)metrics { return @"metrics";}
//+(NSString*)language { return @"language";}
//+(NSString*)sessionMetrics { return @"sessionMetrics";}
//+(NSString*)nodeTypeString { return @"nodeTypeString";}
//+(NSString*)adNumber { return @"adNumber";}
//+(NSString*)fps { return @"fps";}
//+(NSString*)throughput { return @"throughput";}
//+(NSString*)p2pDownloadedTraffic { return @"p2pDownloadedTraffic";}
//+(NSString*)cdnDownloadedTraffic { return @"cdnDownloadedTraffic";}
//+(NSString*)sessions { return @"sessions";}
//+(NSString*)uploadTraffic { return @"uploadTraffic";}
//+(NSString*)adBufferDuration { return @"adBufferDuration";}
//+(NSString*)parentId { return @"parentId";}
//+(NSString*)totalBytes { return @"totalBytes";}
//@end
//
//// YBConstants with stream protocols
//@implementation YBConstantsStreamProtocol
//    +(NSString*)hds { return @"HDS";}
//    +(NSString*)hls { return @"HLS";}
//    +(NSString*)mss { return @"MSS";}
//    +(NSString*)dash { return @"DASH";}
//    +(NSString*)rtmp { return @"RTMP";}
//    +(NSString*)rtp { return @"RTP";}
//    +(NSString*)rtsp { return @"RTSP";}
//@end
//
//// YBConstants with transport format
//@implementation YBConstantsTransportFormat
//    +(NSString*)hlsTs { return @"HLS-TS";}
//    +(NSString*)hlsFmp4 { return @"HLS-FMP4";}
//@end
//
//// Service YBConstants
//@implementation YBConstantsYouboraService
//    /** /data service */
//    +(NSString*)data { return @"/data";}
//    /** /init service */
//    +(NSString*)sInit { return @"/init";}
//    /** /start service */
//    +(NSString*)start { return @"/start";}
//    /** /joinTime service */
//    +(NSString*)join { return @"/joinTime";}
//    /** /pause service */
//    +(NSString*)pause { return @"/pause";}
//    /** /resume service */
//    +(NSString*)resume { return @"/resume";}
//    /** /seek service */
//    +(NSString*)seek { return @"/seek";}
//    /** /bufferUnderrun service */
//    +(NSString*)buffer { return @"/bufferUnderrun";}
//    /** /error service */
//    +(NSString*)error { return @"/error";}
//    /** /stop service */
//    +(NSString*)stop { return @"/stop";}
//    /** /ping service */
//    +(NSString*)ping { return @"/ping";}
//    /** /offlineEvents */
//    +(NSString*)offline { return @"/offlineEvents";}
//    /** /adInit service */
//    +(NSString*)adInit { return @"/adInit";}
//    /** /adStart service */
//    +(NSString*)adStart { return @"/adStart";}
//    /** /adJoin service */
//    +(NSString*)adJoin { return @"/adJoin";}
//    /** /adPause service */
//    +(NSString*)adPause { return @"/adPause";}
//    /** /adResume service */
//    +(NSString*)adResume { return @"/adResume";}
//    /** /adBufferUnderrun service */
//    +(NSString*)adBuffer { return @"/adBufferUnderrun";}
//    /** /adStop service */
//    +(NSString*)adStop { return @"/adStop";}
//    /** /adClick service */
//    +(NSString*)click { return @"/adClick";}
//    /** /adError service */
//    +(NSString*)adError { return @"/adError";}
//    /** /adManifest service */
//    +(NSString*)adManifest { return @"/adManifest";}
//    /** /adBreakStart service */
//    +(NSString*)adBreakStart { return @"/adBreakStart";}
//    /** /adBreakStop service */
//    +(NSString*)adBreakStop { return @"/adBreakStop";}
//    /** /adQuartile service */
//    +(NSString*)adQuartile { return @"/adQuartile";}
//@end
//
//// Infinity service YBConstants
//@implementation YBConstantsYouboraInfinity
//    /** /infinity/session/start service **/
//    +(NSString*)sessionStart { return @"/infinity/session/start";}
//    /** /infinity/session/stop service **/
//    +(NSString*)sessionStop { return @"/infinity/session/stop";}
//    /** /infinity/session/nav service **/
//    +(NSString*)sessionNav { return @"/infinity/session/nav";}
//    /** /infinity/session/event service **/
//    +(NSString*)sessionEvent { return @"/infinity/session/event";}
//    /** /infinity/session/beat service **/
//    +(NSString*)sessionBeat { return @"/infinity/session/beat";}
//    /** /infinity/video/event service **/
//    +(NSString*)videoEvent { return @"/infinity/video/event";}
//@end
//
//// Infinity service YBConstants
//@implementation YBConstantsErrorParams
//    /** Key to save code in error parameters **/
//    +(NSString*)code { return @"errorCode";}
//    /** Key to save message in error parameters **/
//    +(NSString*)message { return @"errorMsg";}
//    /** Key to save metadata in error parameters **/
//    +(NSString*)metadata { return @"errorMetadata";}
//    /** Key to save the level in error parameters **/
//    +(NSString*)level { return @"errorLevel";}
//@end
