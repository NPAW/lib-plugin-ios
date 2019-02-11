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
#import "YBConstants.h"
#import "YBYouboraUtils.h"
#import "YBInfinity.h"

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
            
            NSArray * startParams = @[@"accountCode", @"username", @"rendition", @"title",
                                      @"title2", @"live", @"mediaDuration", @"mediaResource", @"transactionCode", @"properties",
                                      @"cdn", @"playerVersion", @"param1", @"param2", @"param3", @"param4", @"param5", @"param6",
                                      @"param7", @"param8", @"param9", @"param10", @"param11", @"param12", @"param13", @"param14",
                                      @"param15", @"param16", @"param17", @"param18", @"param19", @"param20", @"pluginVersion",
                                      @"pluginInfo", @"isp", @"connectionType", @"ip", @"deviceCode", @"preloadDuration",@"player",
                                      @"deviceInfo", @"userType", @"streamingProtocol", @"experiments", @"obfuscateIp", @"householdId", @"navContext", @"anonymousUser",
                                      @"smartswitchConfigCode", @"smartswitchGroupCode", @"smartswitchContractCode", @"nodeHost", @"nodeType", @"appName", @"appReleaseVersion"];
            
            NSArray * adStartParams = @[@"playhead", @"adTitle", @"adPosition", @"adDuration", @"adResource", @"adCampaign",
                                        @"adPlayerVersion", @"adProperties", @"adAdapterVersion", @"extraparam1",
                                        @"extraparam2", @"extraparam3", @"extraparam4", @"extraparam5", @"extraparam6",
                                        @"extraparam7", @"extraparam8", @"extraparam9", @"extraparam10"];
            
            youboraRequestParams = @{
                       YouboraServiceData:  @[@"system", @"pluginVersion", @"username", @"isInfinity", @"fingerprint"],
                       YouboraServiceInit:  startParams,
                       YouboraServiceStart: startParams,
                       YouboraServiceJoin:  @[@"joinDuration", @"playhead"],
                       YouboraServicePause: @[@"playhead"],
                       YouboraServiceResume: @[@"pauseDuration", @"playhead"],
                       YouboraServiceSeek: @[@"seekDuration", @"playhead"],
                       YouboraServiceBuffer: @[@"bufferDuration", @"playhead"],
                       YouboraServiceStop: @[@"bitrate", @"playhead"],
                       YouboraServiceAdInit: adStartParams,
                       YouboraServiceAdStart: adStartParams,
                       YouboraServiceAdJoin: @[@"adPosition", @"adJoinDuration", @"adPlayhead", @"playhead"],
                       YouboraServiceAdPause: @[@"adPosition", @"adPlayhead", @"playhead"],
                       YouboraServiceAdResume: @[@"adPosition", @"adPlayhead", @"adPauseDuration", @"playhead"],
                       YouboraServiceAdBuffer: @[@"adPosition", @"adPlayhead", @"adBufferDuration", @"playhead"],
                       YouboraServiceAdStop: @[@"adPosition", @"adPlayhead", @"adBitrate", @"adTotalDuration", @"playhead"],
                       YouboraServiceClick: @[@"adPosition", @"adPlayhead", @"adUrl", @"playhead"],
                       YouboraServiceAdError: [adStartParams arrayByAddingObjectsFromArray:@[@"adTotalDuration",@"adPlayhead"]],
                       YouboraServicePing: @[@"droppedFrames", @"playrate", @"latency", @"packetLoss", @"packetSent"],
                       YouboraServiceError: [startParams arrayByAddingObject:@"player"],
                       
                       //Infinity
                       YouboraServiceSessionStart: @[@"accountCode", @"username", @"navContext", @"language", @"pluginInfo", @"appName", @"appReleaseVersion"],
                       YouboraServiceSessionStop: @[@"accountCode"],
                       YouboraServiceSessionNav: @[@"username", @"navContext"],
                       YouboraServiceSessionBeat: @[],
                       YouboraServiceSessionEvent: @[@"navContext"]
            };
            
            youboraRequestParamsDifferent = @{YouboraServiceJoin:     @[@"title", @"title2", @"live", @"mediaDuration", @"mediaResource"],
                                YouboraServiceAdJoin:   @[@"adTitle", @"adDuration", @"adResource"]};
            
            youboraPingEntities = @[@"rendition", @"title", @"title2",
                             @"live", @"mediaDuration", @"mediaResource", @"param1", @"param2", @"param3", @"param4",
                             @"param5", @"param6", @"param7", @"param8", @"param9", @"param10", @"connectionType",
                             @"deviceCode", @"ip", @"username", @"cdn", @"nodeHost", @"nodeType", @"nodeTypeString"];
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
    NSString * sAdNumber = self.lastSent[@"adNumber"];
    
    if (sAdNumber != nil) {
        NSString * position = self.lastSent[@"adPosition"];
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
    
    self.lastSent[@"adNumber"] = sAdNumber;
    
    return sAdNumber;
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
    
    if ([param isEqualToString:@"playhead"]){
        value = [self.plugin getPlayhead].stringValue;
    } else if ([param isEqualToString:@"playrate"]){
        value = [self.plugin getPlayrate].stringValue;
    } else if ([param isEqualToString:@"fps"]){
        value = [self.plugin getFramesPerSecond].stringValue;
    } else if ([param isEqualToString:@"droppedFrames"]){
        value = [self.plugin getDroppedFrames].stringValue;
    } else if ([param isEqualToString:@"mediaDuration"]){
        value = [self.plugin getDuration].stringValue;
    } else if ([param isEqualToString:@"bitrate"]){
        value = [self.plugin getBitrate].stringValue;
    } else if ([param isEqualToString:@"throughput"]){
        value = [self.plugin getThroughput].stringValue;
    } else if ([param isEqualToString:@"rendition"]){
        value = [self.plugin getRendition];
    } else if ([param isEqualToString:@"title"]){
        value = [self.plugin getTitle];
    } else if ([param isEqualToString:@"title2"]){
        value = [self.plugin getProgram];
    } else if ([param isEqualToString:@"streamingProtocol"]){
        value = [self.plugin getStreamingProtocol];
    } else if ([param isEqualToString:@"live"]){
        NSValue * live = [self.plugin getIsLive];
        if (live != nil) {
            value = [live isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:@"mediaResource"]){
        value = [self.plugin getResource];
        if (!value) {
            value = @"unknown";
        }
    } else if ([param isEqualToString:@"transactionCode"]){
        value = [self.plugin getTransactionCode];
    } else if ([param isEqualToString:@"properties"]){
        value = [self.plugin getContentMetadata];
    } else if ([param isEqualToString:@"playerVersion"]){
        value = [self.plugin getPlayerVersion];
    } else if ([param isEqualToString:@"player"]){
        value = [self.plugin getPlayerName];
    } else if ([param isEqualToString:@"cdn"]){
        value = [self.plugin getCdn];
    } else if ([param isEqualToString:@"pluginVersion"]){
        value = [self.plugin getPluginVersion];
    } else if ([param isEqualToString:@"param1"]){
        value = [self.plugin getCustomDimension1];
    } else if ([param isEqualToString:@"param2"]){
        value = [self.plugin getCustomDimension2];
    } else if ([param isEqualToString:@"param3"]){
        value = [self.plugin getCustomDimension3];
    } else if ([param isEqualToString:@"param4"]){
        value = [self.plugin getCustomDimension4];
    } else if ([param isEqualToString:@"param5"]){
        value = [self.plugin getCustomDimension5];
    } else if ([param isEqualToString:@"param6"]){
        value = [self.plugin getCustomDimension6];
    } else if ([param isEqualToString:@"param7"]){
        value = [self.plugin getCustomDimension7];
    } else if ([param isEqualToString:@"param8"]){
        value = [self.plugin getCustomDimension8];
    } else if ([param isEqualToString:@"param9"]){
        value = [self.plugin getCustomDimension9];
    } else if ([param isEqualToString:@"param10"]){
        value = [self.plugin getCustomDimension10];
    } else if ([param isEqualToString:@"param11"]){
        value = [self.plugin getCustomDimension11];
    } else if ([param isEqualToString:@"param12"]){
        value = [self.plugin getCustomDimension12];
    } else if ([param isEqualToString:@"param13"]){
        value = [self.plugin getCustomDimension13];
    } else if ([param isEqualToString:@"param14"]){
        value = [self.plugin getCustomDimension14];
    } else if ([param isEqualToString:@"param15"]){
        value = [self.plugin getCustomDimension15];
    } else if ([param isEqualToString:@"param16"]){
        value = [self.plugin getCustomDimension16];
    } else if ([param isEqualToString:@"param17"]){
        value = [self.plugin getCustomDimension17];
    } else if ([param isEqualToString:@"param18"]){
        value = [self.plugin getCustomDimension18];
    } else if ([param isEqualToString:@"param19"]){
        value = [self.plugin getCustomDimension19];
    } else if ([param isEqualToString:@"param20"]){
        value = [self.plugin getCustomDimension20];
    } else if ([param isEqualToString:@"extraparam1"]){
        value = [self.plugin getAdCustomDimension1];
    } else if ([param isEqualToString:@"extraparam2"]){
        value = [self.plugin getAdCustomDimension2];
    } else if ([param isEqualToString:@"extraparam3"]){
        value = [self.plugin getAdCustomDimension3];
    } else if ([param isEqualToString:@"extraparam4"]){
        value = [self.plugin getAdCustomDimension4];
    } else if ([param isEqualToString:@"extraparam5"]){
        value = [self.plugin getAdCustomDimension5];
    } else if ([param isEqualToString:@"extraparam6"]){
        value = [self.plugin getAdCustomDimension6];
    } else if ([param isEqualToString:@"extraparam7"]){
        value = [self.plugin getAdCustomDimension7];
    } else if ([param isEqualToString:@"extraparam8"]){
        value = [self.plugin getAdCustomDimension8];
    } else if ([param isEqualToString:@"extraparam9"]){
        value = [self.plugin getAdCustomDimension9];
    } else if ([param isEqualToString:@"extraparam10"]){
        value = [self.plugin getAdCustomDimension10];
    } else if ([param isEqualToString:@"adPosition"]){
        value = [self.plugin getAdPosition];
    } else if ([param isEqualToString:@"adPlayhead"]){
        value = [self.plugin getAdPlayhead].stringValue;
    } else if ([param isEqualToString:@"adDuration"]){
        value = [self.plugin getAdDuration].stringValue;
    } else if ([param isEqualToString:@"adBitrate"]){
        value = [self.plugin getAdBitrate].stringValue;
    } else if ([param isEqualToString:@"adTitle"]){
        value = [self.plugin getAdTitle];
    } else if ([param isEqualToString:@"adCampaign"]){
        value = [self.plugin getAdCampaign];
    } else if ([param isEqualToString:@"adResource"]){
        value = [self.plugin getAdResource];
    } else if ([param isEqualToString:@"adPlayerVersion"]){
        value = [self.plugin getAdPlayerVersion];
    } else if ([param isEqualToString:@"adProperties"]){
        value = [self.plugin getAdMetadata];
    } else if ([param isEqualToString:@"adAdapterVersion"]){
        value = [self.plugin getAdAdapterVersion];
    } else if ([param isEqualToString:@"pluginInfo"]){
        value = [self.plugin getPluginInfo];
    } else if ([param isEqualToString:@"isp"]){
        value = [self.plugin getIsp];
    } else if ([param isEqualToString:@"connectionType"]){
        value = [self.plugin getConnectionType];
    } else if ([param isEqualToString:@"ip"]){
        value = [self.plugin getIp];
    } else if ([param isEqualToString:@"deviceCode"]){
        value = [self.plugin getDeviceCode];
    } else if ([param isEqualToString:@"system"]){
        value = [self.plugin getAccountCode];
    } else if ([param isEqualToString:@"accountCode"]){
        value = [self.plugin getAccountCode];
    } else if ([param isEqualToString:@"username"]){
        value = [self.plugin getUsername];
    }else if ([param isEqualToString:@"userType"]){
        value = [self.plugin getUserType];
    } else if ([param isEqualToString:@"preloadDuration"]){
        long long duration = [self.plugin getPreloadDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"joinDuration"]){
        long long duration = [self.plugin getJoinDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"bufferDuration"]){
        long long duration = [self.plugin getBufferDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"seekDuration"]){
        long long duration = [self.plugin getSeekDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"pauseDuration"]){
        long long duration = [self.plugin getPauseDuration];
        if (duration < 0) duration = 0;
        value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adJoinDuration"]){
        long long duration = [self.plugin getAdJoinDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adBufferDuration"]){
        long long duration = [self.plugin getAdBufferDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adPauseDuration"]){
        long long duration = [self.plugin getAdPauseDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adTotalDuration"]){
        long long duration = [self.plugin getAdTotalDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"nodeHost"]){
        value = [self.plugin getNodeHost];
    } else if ([param isEqualToString:@"nodeType"]){
        value = [self.plugin getNodeType];
    } else if ([param isEqualToString:@"nodeTypeString"]){
        value = [self.plugin getNodeTypeString];
    } else if ([param isEqualToString:@"deviceInfo"]){
        value = [self.plugin getDeviceInfoString];
    } else if ([param isEqualToString:@"householdId"]){
        value = [self.plugin getHouseholdId];
    }  else if ([param isEqualToString:@"p2pDownloadedTraffic"]){
        value = [self.plugin getP2PTraffic];
    }  else if ([param isEqualToString:@"cdnDownloadedTraffic"]){
        value = [self.plugin getCdnTraffic];
    }  else if ([param isEqualToString:@"uploadTraffic"]){
        value = [self.plugin getUploadTraffic];
    }  else if ([param isEqualToString:@"experiments"]){
        NSArray *experimentsArray = [self.plugin getExperimentIds];
        if(experimentsArray == nil || (experimentsArray != nil && [experimentsArray count] == 0)){
            value = nil;
        }else{
            NSString *experimentsString = [experimentsArray componentsJoinedByString:@"\",\""];
            value = [NSString stringWithFormat:@"[\"%@\"]",experimentsString];
        }
    } else if ([param isEqualToString:@"latency"]){
        value = [[self.plugin getLatency] stringValue];
    } else if ([param isEqualToString:@"packetLoss"]){
        value = [[self.plugin getPacketLost] stringValue];
    } else if ([param isEqualToString:@"packetSent"]){
        value = [[self.plugin getPacketSent] stringValue];
    } else if ([param isEqualToString:@"obfuscateIp"]){
        NSValue * obfuscate = [self.plugin getNetworkObfuscateIp];
        if (obfuscate != nil) {
            value = [obfuscate isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:@"navContext"]) {
        value = ((YBInfinity *)[YBInfinity sharedManager]).navContext;
    } else if ([param isEqualToString:@"sessions"]) {
        value = [YBYouboraUtils stringifyList:[self.plugin getActiveSessions]];
    } else if ([param isEqualToString:@"anonymousUser"]){
        value = [self.plugin getAnonymousUser];
    } else if ([param isEqualToString:@"isInfinity"]) {
        NSValue * isInfinity = [self.plugin getIsInfinity];
        if (isInfinity != nil) {
            value = [isInfinity isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:@"smartswitchConfigCode"]) {
        value = [self.plugin getSmartSwitchConfigCode];
    } else if ([param isEqualToString:@"smartswitchGroupCode"]) {
        value = [self.plugin getSmartSwitchGroupCode];
    } else if ([param isEqualToString:@"smartswitchContractCode"]) {
        value = [self.plugin getSmartSwitchContractCode];
    } else if ([param isEqualToString:@"appName"]) {
        value = [self.plugin getAppName];
    } else if ([param isEqualToString:@"appReleaseVersion"]) {
        value = [self.plugin getAppReleaseVersion];
    } else if ([param isEqualToString:@"fingerprint"]) {
        value = [self.plugin getFingerprint];
    }
    
    return value;
}
@end
