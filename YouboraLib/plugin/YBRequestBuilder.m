//
//  YBRequestBuilder.m
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBRequestBuilder.h"
#import "YBPlugin.h"
#import "YBLog.h"
#import "YBInfinity.h"
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBRequestBuilder()

@property(nonatomic, weak) YBPlugin * plugin;
@property(nonatomic, strong, readwrite) NSMutableDictionary * lastSent;

@end

@implementation YBRequestBuilder

/** Lists of params used by each service */
static NSDictionary<NSString *, NSArray<NSString *> *> * youboraRequestParams;

/** Lists of params used by each service (only if they are different) */
static NSDictionary<NSString *, NSArray<NSString *> *> * youboraRequestParamsDifferent;

/** Array of entities that should be reported in pings if they change mid-view */
static NSArray<NSString *> * youboraPingEntities;

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.plugin = nil;
        self.lastSent = [NSMutableDictionary dictionary];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            NSMutableArray * startParams = [NSMutableArray arrayWithArray:@[
                YBConstantsRequest.accountCode,
                YBConstantsRequest.username,
                YBConstantsRequest.rendition,
                YBConstantsRequest.title,
                YBConstantsRequest.title2,
                YBConstantsRequest.live,
                YBConstantsRequest.mediaDuration,
                YBConstantsRequest.mediaResource,
                YBConstantsRequest.parsedResource,
                YBConstantsRequest.transactionCode,
                YBConstantsRequest.properties,
                YBConstantsRequest.cdn,
                YBConstantsRequest.playerVersion,
                YBConstantsRequest.param1,
                YBConstantsRequest.param2,
                YBConstantsRequest.param3,
                YBConstantsRequest.param4,
                YBConstantsRequest.param5,
                YBConstantsRequest.param6,
                YBConstantsRequest.param7,
                YBConstantsRequest.param8,
                YBConstantsRequest.param9,
                YBConstantsRequest.param10,
                YBConstantsRequest.param11,
                YBConstantsRequest.param12,
                YBConstantsRequest.param13,
                YBConstantsRequest.param14,
                YBConstantsRequest.param15,
                YBConstantsRequest.param16,
                YBConstantsRequest.param17,
                YBConstantsRequest.param18,
                YBConstantsRequest.param19,
                YBConstantsRequest.param20,
                YBConstantsRequest.dimensions,
                YBConstantsRequest.adBlockerDetected,
                YBConstantsRequest.pluginVersion,
                YBConstantsRequest.pluginInfo,
                YBConstantsRequest.isp,
                YBConstantsRequest.connectionType,
                YBConstantsRequest.ip,
                YBConstantsRequest.deviceCode,
                YBConstantsRequest.preloadDuration,
                YBConstantsRequest.player,
                YBConstantsRequest.deviceInfo,
                YBConstantsRequest.userType,
                YBConstantsRequest.streamingProtocol,
                YBConstantsRequest.transportFormat,
                YBConstantsRequest.experiments,
                YBConstantsRequest.obfuscateIp,
                YBConstantsRequest.householdId,
                YBConstantsRequest.navContext,
                YBConstantsRequest.anonymousUser,
                YBConstantsRequest.smartswitchConfigCode,
                YBConstantsRequest.smartswitchGroupCode,
                YBConstantsRequest.smartswitchContractCode,
                YBConstantsRequest.nodeHost,
                YBConstantsRequest.nodeType,
                YBConstantsRequest.appName,
                YBConstantsRequest.appReleaseVersion,
                YBConstantsRequest.email,
                YBConstantsRequest.package,
                YBConstantsRequest.saga,
                YBConstantsRequest.tvshow,
                YBConstantsRequest.season,
                YBConstantsRequest.titleEpisode,
                YBConstantsRequest.channel,
                YBConstantsRequest.contentId,
                YBConstantsRequest.imdbID,
                YBConstantsRequest.gracenoteID,
                YBConstantsRequest.contentType,
                YBConstantsRequest.genre,
                YBConstantsRequest.contentLanguage,
                YBConstantsRequest.subtitles,
                YBConstantsRequest.contractedResolution,
                YBConstantsRequest.cost,
                YBConstantsRequest.price,
                YBConstantsRequest.playbackType,
                YBConstantsRequest.drm,
                YBConstantsRequest.videoCodec,
                YBConstantsRequest.audioCodec,
                YBConstantsRequest.codecSettings,
                YBConstantsRequest.codecProfile,
                YBConstantsRequest.containerFormat,
                YBConstantsRequest.adsExpected,
                YBConstantsRequest.deviceUUID,
                YBConstantsRequest.deviceEDID,
                YBConstantsRequest.p2pEnabled,
                YBConstantsRequest.parentId,
                YBConstantsRequest.linkedViewId
            ]];
            
            NSArray * adStartParams = @[
                YBConstantsRequest.playhead,
                YBConstantsRequest.adTitle,
                YBConstantsRequest.position,
                YBConstantsRequest.adDuration,
                YBConstantsRequest.adResource,
                YBConstantsRequest.adCampaign,
                YBConstantsRequest.adPlayerVersion,
                YBConstantsRequest.adProperties,
                YBConstantsRequest.adAdapterVersion,
                YBConstantsRequest.adInsertionType,
                YBConstantsRequest.extraparam1,
                YBConstantsRequest.extraparam2,
                YBConstantsRequest.extraparam3,
                YBConstantsRequest.extraparam4,
                YBConstantsRequest.extraparam5,
                YBConstantsRequest.extraparam6,
                YBConstantsRequest.extraparam7,
                YBConstantsRequest.extraparam8,
                YBConstantsRequest.extraparam9,
                YBConstantsRequest.extraparam10,
                YBConstantsRequest.skippable,
                YBConstantsRequest.breakNumber,
                YBConstantsRequest.adCreativeId,
                YBConstantsRequest.adProvider,
                YBConstantsRequest.adBlockerDetected
            ];
            
            NSMutableArray *initParams = [[NSMutableArray alloc] initWithArray:startParams];
            [initParams removeObject:YBConstantsRequest.rendition];
            
            youboraRequestParams = @{
                       YBConstantsYouboraService.data:  @[
                               YBConstantsRequest.system,
                               YBConstantsRequest.pluginVersion,
                               YBConstantsRequest.username,
                               YBConstantsRequest.isInfinity
                       ],
                       YBConstantsYouboraService.sInit: initParams,
                       YBConstantsYouboraService.start: startParams,
                       YBConstantsYouboraService.join:  @[YBConstantsRequest.joinDuration, YBConstantsRequest.playhead],
                       YBConstantsYouboraService.pause: @[YBConstantsRequest.playhead],
                       YBConstantsYouboraService.resume: @[YBConstantsRequest.pauseDuration, YBConstantsRequest.playhead],
                       YBConstantsYouboraService.seek: @[YBConstantsRequest.seekDuration, YBConstantsRequest.playhead],
                       YBConstantsYouboraService.buffer: @[YBConstantsRequest.bufferDuration, YBConstantsRequest.playhead],
                       YBConstantsYouboraService.stop: @[
                               YBConstantsRequest.bitrate,
                               YBConstantsRequest.playhead,
                               YBConstantsRequest.totalBytes,
                               YBConstantsRequest.pauseDuration,
                               YBConstantsRequest.metrics
                       ],
                       YBConstantsYouboraService.adInit: adStartParams,
                       YBConstantsYouboraService.adStart: adStartParams,
                       YBConstantsYouboraService.adJoin: @[
                               YBConstantsRequest.position,
                               YBConstantsRequest.adJoinDuration,
                               YBConstantsRequest.adPlayhead,
                               YBConstantsRequest.playhead
                       ],
                       YBConstantsYouboraService.adPause: @[YBConstantsRequest.position, YBConstantsRequest.adPlayhead, YBConstantsRequest.playhead, YBConstantsRequest.breakNumber],
                       YBConstantsYouboraService.adResume: @[YBConstantsRequest.position, YBConstantsRequest.adPlayhead, YBConstantsRequest.adPauseDuration, YBConstantsRequest.playhead, YBConstantsRequest.breakNumber],
                       YBConstantsYouboraService.adBuffer: @[YBConstantsRequest.position, YBConstantsRequest.adPlayhead, YBConstantsRequest.adBufferDuration, YBConstantsRequest.playhead, YBConstantsRequest.breakNumber],
                       YBConstantsYouboraService.adStop: @[YBConstantsRequest.position, YBConstantsRequest.adPlayhead, YBConstantsRequest.adBitrate, YBConstantsRequest.adTotalDuration, YBConstantsRequest.playhead, YBConstantsRequest.breakNumber, YBConstantsRequest.adViewedDuration, YBConstantsRequest.adViewability],
                       YBConstantsYouboraService.click: @[
                               YBConstantsRequest.position,
                               YBConstantsRequest.adPlayhead,
                               YBConstantsRequest.adUrl,
                               YBConstantsRequest.playhead
                       ],
                       YBConstantsYouboraService.adError: [
                                                           adStartParams arrayByAddingObjectsFromArray:@[
                                                               YBConstantsRequest.adTotalDuration,
                                                               YBConstantsRequest.adPlayhead,
                                                               YBConstantsRequest.player]
                                                           ],
                       YBConstantsYouboraService.adManifest: @[YBConstantsRequest.givenBreaks, YBConstantsRequest.expectedBreaks, YBConstantsRequest.expectedPattern, YBConstantsRequest.breaksTime],
                       YBConstantsYouboraService.adBreakStart: @[YBConstantsRequest.position, YBConstantsRequest.givenAds, YBConstantsRequest.expectedAds, YBConstantsRequest.adInsertionType],
                       YBConstantsYouboraService.adBreakStop: @[YBConstantsRequest.position, YBConstantsRequest.breakNumber],
                       YBConstantsYouboraService.adQuartile: @[YBConstantsRequest.position, YBConstantsRequest.adViewedDuration, YBConstantsRequest.adViewability, YBConstantsRequest.breakNumber],
                       YBConstantsYouboraService.ping: @[
                               YBConstantsRequest.droppedFrames,
                               YBConstantsRequest.playrate,
                               YBConstantsRequest.latency,
                               YBConstantsRequest.packetLoss,
                               YBConstantsRequest.packetSent,
                               YBConstantsRequest.metrics,
                               YBConstantsRequest.totalBytes
                       ],
                       YBConstantsYouboraService.error: [
                                                         startParams arrayByAddingObjectsFromArray:@[
                                                         YBConstantsRequest.player,
                                                         YBConstantsRequest.playhead]
                                                         ],
                       
                       //Infinity
                       YBConstantsYouboraInfinity.sessionStart: @[YBConstantsRequest.accountCode, YBConstantsRequest.username, YBConstantsRequest.navContext, YBConstantsRequest.language, YBConstantsRequest.pluginInfo, YBConstantsRequest.appName, YBConstantsRequest.appReleaseVersion, YBConstantsRequest.param1,                               YBConstantsRequest.param2, YBConstantsRequest.param3, YBConstantsRequest.param4, YBConstantsRequest.param5, YBConstantsRequest.param6, YBConstantsRequest.param7, YBConstantsRequest.param8, YBConstantsRequest.param9, YBConstantsRequest.param10, YBConstantsRequest.param11,
                                                     YBConstantsRequest.param12, YBConstantsRequest.param13, YBConstantsRequest.param14, YBConstantsRequest.param15, YBConstantsRequest.param16, YBConstantsRequest.param17, YBConstantsRequest.param18, YBConstantsRequest.param19, YBConstantsRequest.param20, YBConstantsRequest.dimensions, YBConstantsRequest.deviceUUID, YBConstantsRequest.deviceEDID, YBConstantsRequest.deviceCode,
                                                         YBConstantsRequest.obfuscateIp,
                                                         YBConstantsRequest.ip,
                                                         YBConstantsRequest.isp,
                                                         YBConstantsRequest.connectionType,
                                                         YBConstantsRequest.userType,
                                                         YBConstantsRequest.deviceInfo,
                                                         YBConstantsRequest.linkedViewId,
                                                         YBConstantsRequest.adBlockerDetected],
                       YBConstantsYouboraInfinity.sessionStop: @[YBConstantsRequest.accountCode, YBConstantsRequest.sessionMetrics],
                       YBConstantsYouboraInfinity.sessionNav: @[YBConstantsRequest.username, YBConstantsRequest.navContext],
                       YBConstantsYouboraInfinity.sessionBeat: @[YBConstantsRequest.sessionMetrics],
                       YBConstantsYouboraInfinity.sessionEvent: @[YBConstantsRequest.navContext],
                       YBConstantsYouboraInfinity.videoEvent: @[]
            };
            
            youboraRequestParamsDifferent = @{YBConstantsYouboraService.join:     @[YBConstantsRequest.title, YBConstantsRequest.title2, YBConstantsRequest.live, YBConstantsRequest.mediaDuration, YBConstantsRequest.mediaResource],
                                YBConstantsYouboraService.adJoin:   @[YBConstantsRequest.adTitle, YBConstantsRequest.adDuration, YBConstantsRequest.adResource]};
            
            youboraPingEntities = @[YBConstantsRequest.rendition, YBConstantsRequest.title, YBConstantsRequest.title2,
                             YBConstantsRequest.live, YBConstantsRequest.mediaDuration, YBConstantsRequest.mediaResource, YBConstantsRequest.param1, YBConstantsRequest.param2, YBConstantsRequest.param3, YBConstantsRequest.param4,
                             YBConstantsRequest.param5, YBConstantsRequest.param6, YBConstantsRequest.param7, YBConstantsRequest.param8, YBConstantsRequest.param9, YBConstantsRequest.param10, YBConstantsRequest.connectionType,
                             YBConstantsRequest.deviceCode, YBConstantsRequest.ip, YBConstantsRequest.username, YBConstantsRequest.cdn, YBConstantsRequest.nodeHost, YBConstantsRequest.nodeType, YBConstantsRequest.nodeTypeString,YBConstantsRequest.subtitles];
        });
    }
    return self;
}

- (instancetype) initWithPlugin:(YBPlugin *)plugin {
    self = [self init];
    
    self.plugin = plugin;
    
    return self;
}

#pragma mark - Public methods
- (NSMutableDictionary<NSString *, NSString *> *) buildParams:(NSDictionary<NSString *, NSString *> *) params forService:(NSString *) service {
    NSMutableDictionary * mutParams = [self fetchParams:params paramList:youboraRequestParams[service] onlyDifferent:false];
    mutParams = [self fetchParams:mutParams paramList:youboraRequestParamsDifferent[service] onlyDifferent:true];
    mutParams[@"timemark"] = [NSString stringWithFormat:@"%.0lf",[YBYouboraUtils unixTimeNow]];
    return mutParams;
}

- (NSMutableDictionary<NSString *, NSString *> *) fetchParams:(NSDictionary<NSString *, NSString *> *)params paramList:(NSArray <NSString *> *) paramList onlyDifferent:(bool) different{
    NSMutableDictionary * mutParams;
    if (params == nil) {
        mutParams = [NSMutableDictionary dictionary];
    } else {
        if ([params isKindOfClass:[NSMutableDictionary class]]) {
            mutParams = (NSMutableDictionary *) params;
        } else {
            mutParams = [params mutableCopy];
        }
    }
    
    if (paramList != nil) {
        for (NSString * param in paramList) {
            if (mutParams[param] != nil) {
                continue; // Para already informed
            }
            
            NSString * value = [self getParamValue:param];
            
            if (value != nil && (!different || ![value isEqualToString:self.lastSent[param]])) {
                mutParams[param] = value;
                self.lastSent[param] = value;
            }
        }
    }
    
    return mutParams;
}

- (NSString *) getNewAdNumber {
    NSString * sAdNumber = self.lastSent[YBConstantsRequest.adNumber];
    
    if (sAdNumber != nil) {
        NSString * position = self.lastSent[YBConstantsRequest.position];
        if (position != nil && [position isEqualToString:[self.plugin getAdPosition]]) {
            // Increment
            @try {
                int num = sAdNumber.intValue;
                sAdNumber = @(num + 1).stringValue;
            } @catch (NSException *exception) {
                [YBLog logException:exception]; // should never happen
            }
        } else {
            sAdNumber = nil;
        }
    }
    
    if (sAdNumber == nil) {
        sAdNumber = @"1";
    }
    
    self.lastSent[YBConstantsRequest.adNumber] = sAdNumber;
    
    return sAdNumber;
}

- (NSString *) getNewAdBreakNumber {
    NSString * sAdBreakNumber = self.lastSent[YBConstantsRequest.breakNumber];
    
    if (sAdBreakNumber != nil) {
        @try {
            int num = sAdBreakNumber.intValue;
            sAdBreakNumber = @(num + 1).stringValue;
        } @catch (NSException *exception) {
            [YBLog logException:exception]; // should never happen
        }
    }else {
        sAdBreakNumber = @"1";
    }
    
    self.lastSent[YBConstantsRequest.breakNumber] = sAdBreakNumber;
    
    return sAdBreakNumber;
}

- (NSMutableDictionary *) getChangedEntitites {
    return [self fetchParams:nil paramList:youboraPingEntities onlyDifferent:true];
}

#pragma mark - Private methods
/// ---------------------------------
/// @name Private methods
/// ---------------------------------

/**
 * Get the actual value for any param asking the Plugin for it.
 * @param param the param name to fetch
 * @return the param value, or null if not available
 */
- (nullable NSString *) getParamValue:(nonnull NSString *) param {
    
    NSString * value = nil;
    
    if ([param isEqualToString:YBConstantsRequest.playhead]){
        value = [self.plugin getPlayhead].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.playrate]){
        value = [self.plugin getPlayrate].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.fps]){
        value = [self.plugin getFramesPerSecond].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.droppedFrames]){
        value = [self.plugin getDroppedFrames].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.mediaDuration]){
        value = [self.plugin getDuration].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.bitrate]){
        NSNumber *tmpValue = [self.plugin getBitrate];
        if (tmpValue) {
            value = tmpValue.stringValue;
        }
    } else if ([param isEqualToString:YBConstantsRequest.totalBytes]){
        NSNumber *tmpValue = [self.plugin getTotalBytes];
        if (tmpValue) {
            value = tmpValue.stringValue;
        }
    } else if ([param isEqualToString:YBConstantsRequest.throughput]){
        value = [self.plugin getThroughput].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.rendition]){
        value = [self.plugin getRendition];
    } else if ([param isEqualToString:YBConstantsRequest.title]){
        value = [self.plugin getTitle];
    } else if ([param isEqualToString:YBConstantsRequest.title2]){
        value = [self.plugin getProgram];
    } else if ([param isEqualToString:YBConstantsRequest.streamingProtocol]){
        value = [self.plugin getStreamingProtocol];
    } else if ([param isEqualToString:YBConstantsRequest.transportFormat]){
        value = [self.plugin getTransportFormat];
    } else if ([param isEqualToString:YBConstantsRequest.live]){
        NSValue * live = [self.plugin getIsLive];
        if (live != nil) {
            value = [live isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:YBConstantsRequest.mediaResource]){
        value = [self.plugin getOriginalResource];
        [YBLog debug:@"original resource: %@", [self.plugin getOriginalResource]];
        if (!value) {
            value = @"unknown";
        }
    } else if ([param isEqualToString:YBConstantsRequest.parsedResource]) {
        value = [self.plugin getParsedResource];
    } else if ([param isEqualToString:YBConstantsRequest.transactionCode]){
        value = [self.plugin getTransactionCode];
    } else if ([param isEqualToString:YBConstantsRequest.properties]){
        value = [self.plugin getContentMetadata];
    } else if ([param isEqualToString:YBConstantsRequest.playerVersion]){
        value = [self.plugin getPlayerVersion];
    } else if ([param isEqualToString:YBConstantsRequest.player]){
        value = [self.plugin getPlayerName];
    } else if ([param isEqualToString:YBConstantsRequest.cdn]){
        value = [self.plugin getCdn];
    } else if ([param isEqualToString:YBConstantsRequest.pluginVersion]){
        value = [self.plugin getPluginVersion];
    } else if ([param isEqualToString:YBConstantsRequest.param1]){
        value = [self.plugin getContentCustomDimension1];
    } else if ([param isEqualToString:YBConstantsRequest.param2]){
        value = [self.plugin getContentCustomDimension2];
    } else if ([param isEqualToString:YBConstantsRequest.param3]){
        value = [self.plugin getContentCustomDimension3];
    } else if ([param isEqualToString:YBConstantsRequest.param4]){
        value = [self.plugin getContentCustomDimension4];
    } else if ([param isEqualToString:YBConstantsRequest.param5]){
        value = [self.plugin getContentCustomDimension5];
    } else if ([param isEqualToString:YBConstantsRequest.param6]){
        value = [self.plugin getContentCustomDimension6];
    } else if ([param isEqualToString:YBConstantsRequest.param7]){
        value = [self.plugin getContentCustomDimension7];
    } else if ([param isEqualToString:YBConstantsRequest.param8]){
        value = [self.plugin getContentCustomDimension8];
    } else if ([param isEqualToString:YBConstantsRequest.param9]){
        value = [self.plugin getContentCustomDimension9];
    } else if ([param isEqualToString:YBConstantsRequest.param10]){
        value = [self.plugin getContentCustomDimension10];
    } else if ([param isEqualToString:YBConstantsRequest.param11]){
        value = [self.plugin getContentCustomDimension11];
    } else if ([param isEqualToString:YBConstantsRequest.param12]){
        value = [self.plugin getContentCustomDimension12];
    } else if ([param isEqualToString:YBConstantsRequest.param13]){
        value = [self.plugin getContentCustomDimension13];
    } else if ([param isEqualToString:YBConstantsRequest.param14]){
        value = [self.plugin getContentCustomDimension14];
    } else if ([param isEqualToString:YBConstantsRequest.param15]){
        value = [self.plugin getContentCustomDimension15];
    } else if ([param isEqualToString:YBConstantsRequest.param16]){
        value = [self.plugin getContentCustomDimension16];
    } else if ([param isEqualToString:YBConstantsRequest.param17]){
        value = [self.plugin getContentCustomDimension17];
    } else if ([param isEqualToString:YBConstantsRequest.param18]){
        value = [self.plugin getContentCustomDimension18];
    } else if ([param isEqualToString:YBConstantsRequest.param19]){
        value = [self.plugin getContentCustomDimension19];
    } else if ([param isEqualToString:YBConstantsRequest.param20]){
        value = [self.plugin getContentCustomDimension20];
    } else if ([param isEqualToString:YBConstantsRequest.dimensions]) {
        value = [self.plugin getCustomDimensions];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam1]){
        value = [self.plugin getAdCustomDimension1];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam2]){
        value = [self.plugin getAdCustomDimension2];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam3]){
        value = [self.plugin getAdCustomDimension3];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam4]){
        value = [self.plugin getAdCustomDimension4];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam5]){
        value = [self.plugin getAdCustomDimension5];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam6]){
        value = [self.plugin getAdCustomDimension6];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam7]){
        value = [self.plugin getAdCustomDimension7];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam8]){
        value = [self.plugin getAdCustomDimension8];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam9]){
        value = [self.plugin getAdCustomDimension9];
    } else if ([param isEqualToString:YBConstantsRequest.extraparam10]){
        value = [self.plugin getAdCustomDimension10];
    } else if ([param isEqualToString:YBConstantsRequest.position]){
        value = [self.plugin getAdPosition];
    } else if ([param isEqualToString:YBConstantsRequest.adPlayhead]){
        value = [self.plugin getAdPlayhead].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adDuration]){
        value = [self.plugin getAdDuration].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adBitrate]){
        value = [self.plugin getAdBitrate].stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adTitle]){
        value = [self.plugin getAdTitle];
    } else if ([param isEqualToString:YBConstantsRequest.adCampaign]){
        value = [self.plugin getAdCampaign];
    } else if ([param isEqualToString:YBConstantsRequest.adResource]){
        value = [self.plugin getAdResource];
    } else if ([param isEqualToString:YBConstantsRequest.adPlayerVersion]){
        value = [self.plugin getAdPlayerVersion];
    } else if ([param isEqualToString:YBConstantsRequest.adProperties]){
        value = [self.plugin getAdMetadata];
    } else if ([param isEqualToString:YBConstantsRequest.adAdapterVersion]){
        value = [self.plugin getAdAdapterVersion];
    } else if ([param isEqualToString:YBConstantsRequest.adInsertionType]){
        value = [self.plugin getAdInsertionType];
    } else if ([param isEqualToString:YBConstantsRequest.pluginInfo]){
        value = [self.plugin getPluginInfo];
    } else if ([param isEqualToString:YBConstantsRequest.isp]){
        value = [self.plugin getIsp];
    } else if ([param isEqualToString:YBConstantsRequest.connectionType]){
        value = [self.plugin getConnectionType];
    } else if ([param isEqualToString:YBConstantsRequest.ip]){
        value = [self.plugin getIp];
    } else if ([param isEqualToString:YBConstantsRequest.deviceCode]){
        value = [self.plugin getDeviceCode];
    } else if ([param isEqualToString:YBConstantsRequest.system]){
        value = [self.plugin getAccountCode];
    } else if ([param isEqualToString:YBConstantsRequest.accountCode]){
        value = [self.plugin getAccountCode];
    } else if ([param isEqualToString:YBConstantsRequest.username]){
        value = [self.plugin getUsername];
    }else if ([param isEqualToString:YBConstantsRequest.userType]){
        value = [self.plugin getUserType];
    } else if ([param isEqualToString:YBConstantsRequest.preloadDuration]){
        long long duration = [self.plugin getPreloadDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.joinDuration]){
        long long duration = [self.plugin getJoinDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.bufferDuration]){
        long long duration = [self.plugin getBufferDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.seekDuration]){
        long long duration = [self.plugin getSeekDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.pauseDuration]){
        long long duration = [self.plugin getPauseDuration];
        if (duration < 0) duration = 0;
        value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adJoinDuration]){
        long long duration = [self.plugin getAdJoinDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adBufferDuration]){
        long long duration = [self.plugin getAdBufferDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adPauseDuration]){
        long long duration = [self.plugin getAdPauseDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.adTotalDuration]){
        long long duration = [self.plugin getAdTotalDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:YBConstantsRequest.nodeHost]){
        value = [self.plugin getNodeHost];
    } else if ([param isEqualToString:YBConstantsRequest.nodeType]){
        value = [self.plugin getNodeType];
    } else if ([param isEqualToString:YBConstantsRequest.nodeTypeString]){
        value = [self.plugin getNodeTypeString];
    } else if ([param isEqualToString:YBConstantsRequest.deviceInfo]){
        value = [self.plugin getDeviceInfoString];
    } else if ([param isEqualToString:YBConstantsRequest.householdId]){
        value = [self.plugin getHouseholdId];
    }  else if ([param isEqualToString:YBConstantsRequest.p2pDownloadedTraffic]){
        value = [[self.plugin getP2PTraffic] stringValue];
    }  else if ([param isEqualToString:YBConstantsRequest.cdnDownloadedTraffic]){
        value = [[self.plugin getCdnTraffic] stringValue];
    }  else if ([param isEqualToString:YBConstantsRequest.uploadTraffic]){
        value = [[self.plugin getUploadTraffic] stringValue];
    }  else if ([param isEqualToString:YBConstantsRequest.experiments]){
        NSArray *experimentsArray = [self.plugin getExperimentIds];
        if(experimentsArray == nil || (experimentsArray != nil && [experimentsArray count] == 0)){
            value = nil;
        }else{
            NSString *experimentsString = [experimentsArray componentsJoinedByString:@"\",\""];
            value = [NSString stringWithFormat:@"[\"%@\"]",experimentsString];
        }
    } else if ([param isEqualToString:YBConstantsRequest.latency]){
        value = [[self.plugin getLatency] stringValue];
    } else if ([param isEqualToString:YBConstantsRequest.packetLoss]){
        value = [[self.plugin getPacketLost] stringValue];
    } else if ([param isEqualToString:YBConstantsRequest.packetSent]){
        value = [[self.plugin getPacketSent] stringValue];
    } else if ([param isEqualToString:YBConstantsRequest.obfuscateIp]){
        NSValue * obfuscate = [self.plugin getNetworkObfuscateIp];
        if (obfuscate != nil) {
            value = [obfuscate isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:YBConstantsRequest.navContext]) {
        value = [self.plugin getInfinity].navContext;
    } else if ([param isEqualToString:YBConstantsRequest.sessions]) {
        value = [YBYouboraUtils stringifyList:[self.plugin getActiveSessions]];
    } else if ([param isEqualToString:YBConstantsRequest.anonymousUser]){
        value = [self.plugin getAnonymousUser];
    } else if ([param isEqualToString:YBConstantsRequest.isInfinity]) {
        NSValue * isInfinity = [self.plugin getIsInfinity];
        if (isInfinity != nil) {
            value = [isInfinity isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:YBConstantsRequest.smartswitchConfigCode]) {
        value = [self.plugin getSmartSwitchConfigCode];
    } else if ([param isEqualToString:YBConstantsRequest.smartswitchGroupCode]) {
        value = [self.plugin getSmartSwitchGroupCode];
    } else if ([param isEqualToString:YBConstantsRequest.smartswitchContractCode]) {
        value = [self.plugin getSmartSwitchContractCode];
    } else if ([param isEqualToString:YBConstantsRequest.appName]) {
        value = [self.plugin getAppName];
    } else if ([param isEqualToString:YBConstantsRequest.appReleaseVersion]) {
        value = [self.plugin getAppReleaseVersion];
    } else if ([param isEqualToString:YBConstantsRequest.deviceUUID]) {
        value = [self.plugin getDeviceUUID];
    } else if ([param isEqualToString:YBConstantsRequest.deviceEDID]) {
        value = [self.plugin getDeviceEDID];
    } else if ([param isEqualToString:YBConstantsRequest.email]) {
        value = [self.plugin getUserEmail];
    } else if ([param isEqualToString:YBConstantsRequest.package]) {
        value = [self.plugin getContentPackage];
    } else if ([param isEqualToString:YBConstantsRequest.saga]) {
        value = [self.plugin getContentSaga];
    } else if ([param isEqualToString:YBConstantsRequest.tvshow]) {
        value = [self.plugin getContentTvShow];
    } else if ([param isEqualToString:YBConstantsRequest.season]) {
        value = [self.plugin getContentSeason];
    } else if ([param isEqualToString:YBConstantsRequest.titleEpisode]) {
        value = [self.plugin getContentEpisodeTitle];
    } else if ([param isEqualToString:YBConstantsRequest.channel]) {
        value = [self.plugin getContentChannel];
    } else if ([param isEqualToString:YBConstantsRequest.contentId]) {
        value = [self.plugin getContentId];
    } else if ([param isEqualToString:YBConstantsRequest.imdbID]) {
        value = [self.plugin getContentImdbId];
    } else if ([param isEqualToString:YBConstantsRequest.gracenoteID]) {
        value = [self.plugin getContentGracenoteId];
    } else if ([param isEqualToString:YBConstantsRequest.contentType]) {
        value = [self.plugin getContentType];
    } else if ([param isEqualToString:YBConstantsRequest.genre]) {
        value = [self.plugin getContentGenre];
    } else if ([param isEqualToString:YBConstantsRequest.contentLanguage]) {
        value = [self.plugin getContentLanguage];
    } else if ([param isEqualToString:YBConstantsRequest.subtitles]) {
        value = [self.plugin getContentSubtitles];
    } else if ([param isEqualToString:YBConstantsRequest.contractedResolution]) {
        value = [self.plugin getContentContractedResolution];
    } else if ([param isEqualToString:YBConstantsRequest.cost]) {
        value = [self.plugin getContentCost];
    } else if ([param isEqualToString:YBConstantsRequest.price]) {
        value = [self.plugin getContentPrice];
    } else if ([param isEqualToString:YBConstantsRequest.playbackType]) {
        value = [self.plugin getContentPlaybackType];
    } else if ([param isEqualToString:YBConstantsRequest.drm]) {
        value = [self.plugin getContentDrm];
    } else if ([param isEqualToString:YBConstantsRequest.videoCodec]) {
        value = [self.plugin getContentEncodingVideoCodec];
    } else if ([param isEqualToString:YBConstantsRequest.audioCodec]) {
        value = [self.plugin getContentEncodingAudioCodec];
    } else if ([param isEqualToString:YBConstantsRequest.codecSettings]) {
        value = [self.plugin getContentEncodingCodecSettings];
    } else if ([param isEqualToString:YBConstantsRequest.codecProfile]) {
        value = [self.plugin getContentEncodingCodecProfile];
    } else if ([param isEqualToString:YBConstantsRequest.containerFormat]) {
        value = [self.plugin getContentEncodingContainerFormat];
    } else if ([param isEqualToString:YBConstantsRequest.givenBreaks]) {
        value = [self.plugin getAdGivenBreaks];
    } else if ([param isEqualToString:YBConstantsRequest.expectedBreaks]) {
        value = [self.plugin getAdExpectedBreaks];
    } else if ([param isEqualToString:YBConstantsRequest.expectedPattern]) {
        value = [self.plugin getAdExpectedPattern];
    } else if ([param isEqualToString:YBConstantsRequest.breaksTime]) {
        value = [self.plugin getAdBreaksTime];
    } else if ([param isEqualToString:YBConstantsRequest.givenAds]) {
        value = [self.plugin getAdGivenAds];
    } else if ([param isEqualToString:YBConstantsRequest.expectedAds]) {
        value = [self.plugin getExpectedAds];
    } else if ([param isEqualToString:YBConstantsRequest.adsExpected]) {
        NSValue * expected = [self.plugin getAdsExpected];
        if (expected != nil) {
            value = [expected isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:YBConstantsRequest.skippable]) {
        NSValue * skippable = [self.plugin isAdSkippable];
        if (skippable != nil) {
            value = [skippable isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:YBConstantsRequest.breakNumber]) {
        value = [self.plugin getAdBreakNumber];
    } else if ([param isEqualToString: YBConstantsRequest.adViewedDuration]) {
        value = [self.plugin getAdViewedDuration];
    } else if ([param isEqualToString:YBConstantsRequest.adViewability]) {
        value = [self.plugin getAdViewability];
    } else if ([param isEqualToString:YBConstantsRequest.adCreativeId]) {
        value = [self.plugin getAdCreativeId];
    } else if ([param isEqualToString:YBConstantsRequest.adProvider]) {
        value = [self.plugin getAdProvider];
    } else if ([param isEqualToString:YBConstantsRequest.sessionMetrics]) {
        value = [self.plugin getSessionMetrics];
    } else if ([param isEqualToString:YBConstantsRequest.metrics]) {
        value = [self.plugin getVideoMetrics];
    } else if ([param isEqualToString:YBConstantsRequest.p2pEnabled]) {
        value = [[self.plugin getIsP2PEnabled] isEqualToValue:@YES] ? @"true" : @"false";
    } else  if ([param isEqualToString:YBConstantsRequest.parentId]) {
       value = [self.plugin getParentId];
    } else  if ([param isEqualToString:YBConstantsRequest.linkedViewId]) {
        value = [self.plugin getLinkedViewId];
     } else  if ([param isEqualToString:YBConstantsRequest.adBlockerDetected]) {
         NSValue * detected = [self.plugin getAdBlockerDetected];
         if (detected != nil) {
             value = [detected isEqual:@YES] ? @"true" : @"false";
         }
      }
    
    return value;
}
@end
