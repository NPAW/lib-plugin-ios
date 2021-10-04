//
//  YBPlayerAdapter.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlayerAdapter.h"

#import "YBPlaybackChronos.h"
#import "YBPlayheadMonitor.h"
#import "YBLog.h"
#import "YBPlugin.h"
#import "YBOptions.h"

#import "YouboraLib/YouboraLib-Swift.h"

@interface YBPlayerAdapter()

// Delegates list
@property (nonatomic, strong) NSMutableArray<id<YBPlayerAdapterEventDelegate>> * eventDelegates;

// Property that gonna prevent the same error to be sent in less than x seconds
@property(nonatomic, strong) YBErrorHandler *errorHandler;

@end

@implementation YBPlayerAdapter

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = nil;
        self.flags = [YBPlaybackFlags new];
        self.chronos = [YBPlaybackChronos new];
        self.errorHandler = [[YBErrorHandler alloc] initWithSecondsToClean:5];
        
        if ([YBLog isAtLeastLevel:YBLogLevelNotice]) {
            [YBLog notice:@"Adapter %@ with lib %@ is ready.", [self getVersion], YBConstants.youboraLibVersion];
        }
    }
    return self;
}

- (instancetype)initWithPlayer:(id)player {
    self = [self init];
    
    self.player = player;
    
    return self;
}

#pragma mark - Public methods

- (void)registerListeners {
    // Empty implementation, should be overridden in subclasses
}

- (void)unregisterListeners {
    // Empty implementation, should be overridden in subclasses
}

- (void)dispose {
    if (self.monitor != nil) {
        [self.monitor stop];
    }
    
    [self fireStop];
    self.player = nil;
}

- (void)monitorPlayheadWithBuffers:(bool)monitorBuffers seeks:(bool)monitorSeeks andInterval:(int)interval {
    int type = 0;
    if (monitorBuffers) type |= YouboraBufferTypeBuffer;
    if (monitorSeeks) type |= YouboraBufferTypeSeek;
    
    if (type != 0) {
        self.monitor = [self createPlayheadMonitorWithType:type andInterval:interval];
    }
}

- (void)setPlayer:(id)player {
    if (self.player != nil) {
        [self unregisterListeners];
    }
    
    _player = player;
    
    if (self.player != nil) {
        [self registerListeners];
    }
}

// Get methods
- (NSNumber *)getPlayhead {
    return nil;
}

- (NSNumber *)getPlayrate {
    return self.flags.paused? @0 : @1;
}

- (NSNumber *)getFramesPerSecond {
    return nil;
}

- (NSNumber *)getDroppedFrames {
    return nil;
}

- (NSNumber *)getDuration {
    return nil;
}

- (NSNumber *)getBitrate {
    return nil;
}

- (NSNumber *) getTotalBytes {
    return nil;
}

- (NSNumber *)getThroughput {
    return nil;
}

- (NSString *)getRendition {
    return nil;
}

- (NSString *)getTitle {
    return nil;
}

- (NSString *)getTitle2 {
    return nil;
}

- (NSString *)getProgram {
    return nil;
}

- (NSValue *)getIsLive {
    return nil;
}

- (NSString *)getResource {
    return nil;
}

- (NSNumber *)getLatency {
    return nil;
}

- (NSNumber *)getPacketSent {
    return nil;
}

- (NSNumber *)getPacketLost {
    return nil;
}

- (NSString *)getPlayerVersion {
    return nil;
}

- (NSString *)getPlayerName {
    return nil;
}

- (NSString *)getVersion {
    return [YBConstants.youboraLibVersion stringByAppendingString:@"-generic-ios"];
}

- (NSString *) getHouseholdId {
    return nil;
}

-(NSNumber *) getCdnTraffic {
    return nil;
}

-(NSNumber *) getP2PTraffic {
    return nil;
}

-(NSNumber *) getUploadTraffic {
    return nil;
}

-(NSValue *) getIsP2PEnabled {
    return nil;
}

- (NSDictionary<NSString *, NSString *> *) getMetrics {
    return nil;
}

//Ads only

- (YBAdPosition)getPosition {
    return YBAdPositionUnknown;
}

- (NSNumber *) getAdBreakNumber {
    return nil;
}

- (NSNumber *) getAdGivenBreaks {
    return nil;
}

- (NSNumber *) getAdExpectedBreaks {
    return nil;
}

- (NSDictionary<NSString*, NSArray<NSNumber *> *> *) getAdExpectedPattern {
    return nil;
}

- (NSArray *) getAdBreaksTime {
    return nil;
}

- (NSNumber *) getGivenAds {
    return nil;
}

- (NSString *) getAdInsertionType {
    return nil;
}

- (NSNumber *) getExpectedAds {
    return nil;
}

- (NSNumber *) getAdViewedDuration {
    return nil;
}

- (NSNumber *) getAdViewability {
    return nil;
}

- (NSValue *) isSkippable {
    return nil;
}

- (NSString *) getAdCreativeId {
    return nil;
}

- (NSString *) getAdProvider {
    return nil;
}

- (nullable NSString *) getAudioCodec {
    return nil;
}

- (nullable NSString *) getVideoCodec {
    return nil;
}

-(nullable NSString*)getURLToParse {
    return nil;
}

// Fire methods
    
- (void)fireAdInit {
    [self fireAdInit:nil];
}

- (void)fireAdInit: (nullable NSDictionary<NSString *,NSString *> *)params {
    
    if (!self.flags.adInitiated) {
        self.flags.adInitiated = true;
        
        [self.chronos.adInit start];
        [self.chronos.join start];
        [self.chronos.total start];
    }
    
    for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
        [delegate youboraAdapterEventAdInit:params fromAdapter:self];
    }
}
    
- (void)fireStart {
    [self fireStart:nil];
}

- (void)fireStart:(nullable NSDictionary<NSString *,NSString *> *)params {
    if (!self.flags.started || (self.plugin != nil && !self.plugin.isStarted)) {
        self.flags.started = true;
        
        if(!self.flags.adInitiated){
            [self.chronos.join start];
            [self.chronos.total start];
        }else{
            if([self getPosition] != YBAdPositionUnknown && [self getPosition] != YBAdPositionPre){
                [self.chronos.join start];
            }
            [self.chronos.adInit stop];
        }
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventStart:params fromAdapter:self];
        }
    }
}

- (void)fireJoin {
    [self fireJoin:nil];
}

- (void)fireJoin:(NSDictionary<NSString *,NSString *> *)params {
    if (self.flags.started && !self.flags.joined) {
        if (self.monitor != nil) [self.monitor start];
        
        self.flags.joined = true;
        [self.chronos.join stop];
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventJoin:params fromAdapter:self];
        }
    }
}

- (void)firePause {
    [self firePause:nil];
}

- (void)firePause:(NSDictionary<NSString *,NSString *> *)params {
    if (self.flags.joined && !self.flags.paused) {
        self.flags.paused = true;
        [self.chronos.pause start];
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventPause:params fromAdapter:self];
        }
    }
}

- (void)fireResume {
    [self fireResume:nil];
}

- (void)fireResume:(NSDictionary<NSString *,NSString *> *)params {
    if (self.flags.joined && self.flags.paused) {
        self.flags.paused = false;
        [self.chronos.pause stop];
        
        if (self.monitor != nil) {
            [self.monitor skipNextTick];
        }
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventResume:params fromAdapter:self];
        }
    }
}

- (void)fireBufferBegin {
    [self fireBufferBegin:nil convertFromSeek:false];
}

- (void)fireBufferBegin:(bool)convertFromSeek {
    [self fireBufferBegin:nil convertFromSeek:convertFromSeek];
}

- (void)fireBufferBegin:(NSDictionary<NSString *,NSString *> *)params convertFromSeek:(bool)convertFromSeek {
    if (self.flags.joined && !self.flags.buffering) {
        if (self.flags.seeking) {
            if (convertFromSeek) {
                [YBLog notice:@"Converting current buffer to seek"];
                
                self.chronos.buffer = [self.chronos.seek copy];
                [self.chronos.seek reset];
                
                self.flags.seeking = false;
            } else {
                return;
            }
        } else {
            [self.chronos.buffer start];
        }
        
        self.flags.buffering = true;
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventBufferBegin:params convertFromSeek:convertFromSeek fromAdapter:self];
        }
    }
}

- (void)fireBufferEnd {
    [self fireBufferEnd:nil];
}

- (void)fireBufferEnd:(NSDictionary<NSString *,NSString *> *)params {
    if (self.flags.joined && self.flags.buffering) {
        self.flags.buffering = false;
        
        [self.chronos.buffer stop];
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventBufferEnd:params fromAdapter:self];
        }
    }
}

- (void)fireSeekBegin {
    [self fireSeekBegin:nil convertFromBuffer:true];
}

- (void)fireSeekBegin:(bool)convertFromBuffer {
    [self fireSeekBegin:nil convertFromBuffer:convertFromBuffer];
}

- (void)fireSeekBegin:(NSDictionary<NSString *,NSString *> *)params convertFromBuffer:(bool)convertFromBuffer {
    if (self.plugin != nil && self.plugin.options.contentIsLiveNoSeek != nil && [self.plugin.options.contentIsLiveNoSeek isEqualToValue:@YES] && [[self.plugin getIsLive] isEqualToValue:@YES]){
        return;
    }
    if (self.flags.joined && !self.flags.seeking) {
        if (self.flags.buffering) {
            if (convertFromBuffer) {
                [YBLog notice:@"Converting current buffer to seek"];
                
                self.chronos.seek = [self.chronos.buffer copy];
                [self.chronos.buffer reset];
                
                self.flags.buffering = false;
            } else {
                return;
            }
        } else {
            [self.chronos.seek start];
        }
        
        self.flags.seeking = true;
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventSeekBegin:params convertFromBuffer:convertFromBuffer fromAdapter:self];
        }
    }
}

- (void)fireSeekEnd {
    [self fireSeekEnd:nil];
}

- (void)fireSeekEnd:(NSDictionary<NSString *,NSString *> *)params {
    if (self.plugin != nil && self.plugin.options.contentIsLiveNoSeek != nil && [self.plugin.options.contentIsLiveNoSeek isEqualToValue:@YES] && [[self.plugin getIsLive] isEqualToValue:@YES]){
        return;
    }
    if (self.flags.joined && self.flags.seeking) {
        self.flags.seeking = false;
        
        [self.chronos.seek stop];
        
        if (self.monitor != nil) {
            [self.monitor skipNextTick];
        }
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventSeekEnd:params fromAdapter:self];
        }
    }
}

- (void)fireStop {
    [self fireStop:nil];
}

- (void)fireStop:(NSDictionary<NSString *,NSString *> *)params {
    if (self == self.plugin.adsAdapter || [self.plugin isStopReady]) {
        if (self.flags.started || self.flags.adInitiated) {
            if (self.monitor != nil) {
                [self.monitor stop];
            }
            bool wasPaused = self.flags.paused;
            [self.flags reset];
            
            if(self.plugin != nil){
                //We inform of the pauseDuration here to save it before the reset
                if([self.plugin getPauseDuration] > 0 && wasPaused){
                    if(params == nil){
                        params = [[NSDictionary alloc] init];
                    }
                    NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] initWithDictionary:params];
                    mutableParams[YBConstantsRequest.pauseDuration] = [NSString stringWithFormat:@"%lld",[self.chronos.pause getDeltaTime]];
                    params = [[NSDictionary alloc] initWithDictionary:mutableParams];
                }
            }
            
            [self.chronos.total stop];
            [self.chronos.join reset];
            [self.chronos.pause reset];
            [self.chronos.buffer reset];
            [self.chronos.seek reset];
            [self.chronos.adInit reset];
            
            for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
                [delegate youboraAdapterEventStop:params fromAdapter:self];
            }
            
            [self.chronos.adViewedPeriods removeAllObjects];
        }
    }
}

- (void) fireSkip{
    [self fireStop: @{@"skipped" : @"true"}];
}

- (void)fireEventWithName:(NSString *)eventName dimensions:(NSDictionary<NSString *,NSString *> *)dimensions values:(NSDictionary<NSString *,NSNumber *> *)values topLevelDimensions:(NSDictionary<NSString *,NSString *> *)topLevelDimensions {
    if (self.flags.started) {
        eventName = eventName == nil || [eventName isEqualToString:@""] ? @"" : eventName; //Empty string, will get ignored by the backend
        dimensions = dimensions == nil ? @{} : dimensions;
        values = values == nil ? @{} : values;
        topLevelDimensions = topLevelDimensions == nil ? @{} : topLevelDimensions;
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        [params addEntriesFromDictionary:topLevelDimensions];
        params[@"dimensions"] = dimensions;
        params[@"values"] = values;
        params[@"name"] = eventName;
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventVideoEvent:params fromAdapter:self];
        }
    }
}

- (void) fireCast{
    [self fireStop: @{@"casted" : @"true"}];
}

- (void)fireError:(NSDictionary<NSString *,NSString *> *)params {
    NSString *message = params[YBConstantsErrorParams.message];
    NSString *code = params[YBConstantsErrorParams.code];
    
    if (![self.errorHandler isNewErrorWithMessage:message code:code] || [YBYouboraUtils containsStringWithArray:self.plugin.options.ignoreErrors value:code]) {
        return;
    }
    
    [self fireStart];
    self.flags.started = true;
    params = [YBYouboraUtils buildErrorParams:[params mutableCopy]];
    for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
        [delegate youboraAdapterEventError:params fromAdapter:self];
    }
    
    // Fire stop case the error was found in the fatal errors
    if ([YBYouboraUtils containsStringWithArray:self.plugin.options.fatalErrors value:code]) {
        [self fireStop];
    }
}

- (void) fireErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata {
    [self fireError:[YBYouboraUtils buildErrorParamsWithMessage:msg code:code metadata:errorMetadata andLevel:nil]];
}

- (void) fireErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata andException:(nullable NSException *)exception {
    [self fireErrorWithMessage:msg code:code andMetadata:errorMetadata];
}

- (void)fireFatalError:(NSDictionary<NSString *,NSString *> *)params {
    NSMutableDictionary * mutParams;
    if (params != nil) {
        mutParams = [params mutableCopy];
    } else {
        mutParams = [NSMutableDictionary dictionary];
    }
    
    NSString *code = params[YBConstantsErrorParams.code];
    
    // Ignore error because this error is on the list to be ignored
    if ([YBYouboraUtils containsStringWithArray:self.plugin.options.ignoreErrors value:code]) {
        return;
    }
    
    //mutParams[@"errorLevel"] = @"fatal";
    [self fireError:mutParams];
    
    if (![YBYouboraUtils containsStringWithArray:self.plugin.options.nonFatalErrors value:code]) {
        [self fireStop];
    }
}

- (void) fireFatalErrorWithMessage:(nullable NSString *) msg code:(nullable NSString *) code andMetadata:(nullable NSString *) errorMetadata {
    [self fireFatalError:[YBYouboraUtils buildErrorParamsWithMessage:msg code:code metadata:errorMetadata andLevel:@""]];
}

- (void) fireFatalErrorWithMessage:(NSString *)msg code:(NSString *)code andMetadata:(NSString *)errorMetadata andException:(NSException *)exception{
    [self fireFatalErrorWithMessage:msg code:code andMetadata:errorMetadata];
}

- (void) fireClick{
    [self fireClick:[[NSDictionary alloc] init]];
}

- (void) fireClickWithAdUrl:(NSString*)adUrl{
    NSMutableDictionary<NSString *,NSString *>* params = [[NSMutableDictionary alloc] init];
    if(adUrl != nil){
        params[YBConstantsRequest.adUrl] = adUrl;
    }
    [self fireClick:params];
}

- (void) fireClick:(NSDictionary<NSString *,NSString *> *)params{
    for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
        [delegate youboraAdapterEventClick:params fromAdapter:self];
    }
}

- (void) fireAllAdsCompleted{
    [self fireAllAdsCompleted:nil];
}

- (void) fireAllAdsCompleted:(NSDictionary<NSString *,NSString *> *)params{
    for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
        [delegate youboraAdapterEventAllAdsCompleted:params fromAdapter:self];
    }
}

- (void) fireQuartile:(int) quartileNumber {
    if (self.flags.started && quartileNumber > 0 && quartileNumber < 4) {
        NSDictionary * params = @{@"quartile":[NSString stringWithFormat:@"%d",quartileNumber]};
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventAdQuartile:params fromAdapter:self];
        }
    }
}

- (void) fireAdManifest:(nullable NSDictionary<NSString *, NSString *> *) params {
    if (!self.flags.adManifestRequested) {
        self.flags.adManifestRequested = true;
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventAdManifest:params fromAdapter:self];
        }
    }
}

- (void) fireAdManifestWithError:(YBAdManifestError)error andMessage:(NSString *)message {
    if (!self.flags.adManifestRequested) {
        self.flags.adManifestRequested = true;
        NSString *errorType = @"UNKNOWN";
        switch (error) {
            case YBAdManifestEmptyResponse:
                errorType = @"NO_RESPONSE";
                break;
            case YBAdManifestWrongResponse:
                errorType = @"EMPTY_RESPONSE";
                break;
            case YBAdManifestErrorNoResponse:
                errorType = @"WRONG_RESPONSE";
                break;
            default:
                errorType = @"UNKNOWN";
                break;
        }
        
        NSDictionary *params = @{
                                 @"errorType" : errorType,
                                 @"errorMessage" : message
                                 };
        
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventAdManifestError:params fromAdapter:self];
        }
    }
}

- (void) fireAdBreakStart {
    [self fireAdBreakStart:nil];
}

- (void) fireAdBreakStart:(nullable NSDictionary<NSString *, NSString *> *) params {
    if (!self.flags.adBreakStarted) {
        self.flags.adBreakStarted = true;
        if (self.plugin.adapter) {
            [self.plugin.adapter firePause];
        }
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventAdBreakStart:params fromAdapter:self];
        }
    }
}

- (void) fireAdBreakStop {
    [self fireAdBreakStop:nil];
}

- (void) fireAdBreakStop:(NSDictionary<NSString *,NSString *> *)params {
    if (self.flags.adBreakStarted && !self.flags.started) {
        self.flags.adBreakStarted = false;
        for (id<YBPlayerAdapterEventDelegate> delegate in self.eventDelegates) {
            [delegate youboraAdapterEventAdBreakStop:params fromAdapter:self];
        }
        if (self.plugin.adapter) {
            [self.plugin.adapter fireResume];
        }
    }
}

- (void)addYouboraAdapterDelegate:(id<YBPlayerAdapterEventDelegate>)delegate {
    if (delegate != nil) {
        if (self.eventDelegates == nil) {
            self.eventDelegates = [NSMutableArray arrayWithObject:delegate];
        } else if (![self.eventDelegates containsObject:delegate]) {
            [self.eventDelegates addObject:delegate];
        }
    }
}

- (void)removeYouboraAdapterDelegate:(id<YBPlayerAdapterEventDelegate>)delegate {
    if (delegate != nil && self.eventDelegates != nil) {
        [self.eventDelegates removeObject:delegate];
    }
}

- (void) startChronoView {
    if (self == self.plugin.adsAdapter) {
        NSMutableArray<YBChrono *> *periods = self.chronos.adViewedPeriods;
        if ((!periods || !periods.count) || [[periods lastObject] stopTime] != 0) {
            [periods insertObject:[YBChrono new] atIndex:periods.count];
            [[periods lastObject] start];
        }
    }
}

- (void) stopChronoView {
    if (self == self.plugin.adsAdapter) {
        NSMutableArray<YBChrono *> *periods = self.chronos.adViewedPeriods;
        if ([periods firstObject] && periods.count > 0 && [[periods lastObject] stopTime] == 0) {
            [[periods lastObject] stop];
        }
    }
}

#pragma mark - Private methods
- (YBPlayheadMonitor *) createPlayheadMonitorWithType:(int) type andInterval: (int) interval {
    return [[YBPlayheadMonitor alloc] initWithAdapter:self type:type andInterval:interval];
}

@end
