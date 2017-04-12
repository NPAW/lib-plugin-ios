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
                                      @"param7", @"param8", @"param9", @"param10", @"pluginVersion", @"pluginInfo", @"isp",
                                      @"connectionType", @"ip", @"deviceCode", @"preloadDuration"];
            
            youboraRequestParams = @{
                       YouboraServiceData:  @[@"system", @"pluginVersion"],
                       YouboraServiceInit:  startParams,
                       YouboraServiceStart: startParams,
                       YouboraServiceJoin:  @[@"joinDuration", @"playhead"],
                       YouboraServicePause: @[@"playhead"],
                       YouboraServiceResume: @[@"pauseDuration", @"playhead"],
                       YouboraServiceSeek: @[@"seekDuration", @"playhead"],
                       YouboraServiceBuffer: @[@"bufferDuration", @"playhead"],
                       YouboraServiceStop: @[@"bitrate", @"playhead"],
                       YouboraServiceAdStart: @[@"playhead", @"adTitle", @"adPosition", @"adDuration", @"adResource",
                                                @"adPlayerVersion", @"adProperties", @"adAdapterVersion"],
                       YouboraServiceAdJoin: @[@"adPosition", @"adJoinDuration", @"adPlayhead"],
                       YouboraServiceAdPause: @[@"adPosition", @"adPlayhead"],
                       YouboraServiceAdResume: @[@"adPosition", @"adPlayhead", @"adPauseDuration"],
                       YouboraServiceAdBuffer: @[@"adPosition", @"adPlayhead", @"adBufferDuration"],
                       YouboraServiceAdStop: @[@"adPosition", @"adPlayhead", @"adBitrate", @"adTotalDuration"],
                       YouboraServicePing: @[@"droppedFrames", @"playrate"],
                       YouboraServiceError: [startParams arrayByAddingObject:@"player"]
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
        value = [self.plugin getTitle2];
    } else if ([param isEqualToString:@"live"]){
        NSValue * live = [self.plugin getIsLive];
        if (live != nil) {
            value = [live isEqual:@YES] ? @"true" : @"false";
        }
    } else if ([param isEqualToString:@"mediaResource"]){
        value = [self.plugin getResource];
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
        value = [self.plugin getExtraparam1];
    } else if ([param isEqualToString:@"param2"]){
        value = [self.plugin getExtraparam2];
    } else if ([param isEqualToString:@"param3"]){
        value = [self.plugin getExtraparam3];
    } else if ([param isEqualToString:@"param4"]){
        value = [self.plugin getExtraparam4];
    } else if ([param isEqualToString:@"param5"]){
        value = [self.plugin getExtraparam5];
    } else if ([param isEqualToString:@"param6"]){
        value = [self.plugin getExtraparam6];
    } else if ([param isEqualToString:@"param7"]){
        value = [self.plugin getExtraparam7];
    } else if ([param isEqualToString:@"param8"]){
        value = [self.plugin getExtraparam8];
    } else if ([param isEqualToString:@"param9"]){
        value = [self.plugin getExtraparam9];
    } else if ([param isEqualToString:@"param10"]){
        value = [self.plugin getExtraparam10];
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
    } else if ([param isEqualToString:@"preloadDuration"]){
        long duration = [self.plugin getPreloadDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"joinDuration"]){
        long duration = [self.plugin getJoinDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"bufferDuration"]){
        long duration = [self.plugin getBufferDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"seekDuration"]){
        long duration = [self.plugin getSeekDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"pauseDuration"]){
        long duration = [self.plugin getPauseDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adJoinDuration"]){
        long duration = [self.plugin getAdJoinDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adBufferDuration"]){
        long duration = [self.plugin getAdBufferDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adPauseDuration"]){
        long duration = [self.plugin getAdPauseDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"adTotalDuration"]){
        long duration = [self.plugin getAdTotalDuration];
        if (duration >= 0) value = @(duration).stringValue;
    } else if ([param isEqualToString:@"nodeHost"]){
        value = [self.plugin getNodeHost];
    } else if ([param isEqualToString:@"nodeType"]){
        value = [self.plugin getNodeType];
    } else if ([param isEqualToString:@"nodeTypeString"]){
        value = [self.plugin getNodeTypeString];
    }
    
    return value;
}
@end
