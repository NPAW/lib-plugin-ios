//
//  YBPlugin.m
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlugin.h"

#import "YBRequestBuilder.h"
#import "YBOptions.h"
#import "YBLog.h"
#import "YBViewTransform.h"
#import "YBResourceTransform.h"
#import "YBPlayerAdapter.h"
#import "YBRequest.h"
#import "YBCommunication.h"
#import "YBTimer.h"
#import "YBPlaybackChronos.h"
#import "YBFastDataConfig.h"
#import "YBFlowTransform.h"
#import "YBPlayheadMonitor.h"
#import "YBOfflineTransform.h"

#import "YBInfinity.h"
#import "YBInfinityFlags.h"
#import "YBTimestampLastSentTransform.h"
#import "YBConstants.h"
#import "YouboraLib/YouboraLib-Swift.h"
#import "YBCdnSwitchParser.h"

#if TARGET_OS_IPHONE==1
#import <UIKit/UIKit.h>
#endif

@interface YBPlugin()

// Redefinition with readwrite access
@property(nonatomic, strong, readwrite) YBResourceTransform * resourceTransform;
@property(nonatomic, strong, readwrite) YBCdnSwitchParser * cdnSwitchParser;
@property(nonatomic, strong, readwrite) YBViewTransform * viewTransform;
@property(nonatomic, strong, readwrite) YBRequestBuilder * requestBuilder;
@property(nonatomic, strong, readwrite) YBTimer * pingTimer;
@property(nonatomic, strong, readwrite) YBTimer * beatTimer;
@property(nonatomic, strong, readwrite) YBTimer * metadataTimer;
@property(nonatomic, strong, readwrite) YBCommunication * comm;

// Private properties
@property(nonatomic, assign) bool isInitiated;
@property(nonatomic, assign) bool isPreloading;
@property(nonatomic, assign) bool isAdStarted;
@property(nonatomic, assign) int playedPostrolls;
@property(nonatomic, strong) YBChrono * preloadChrono;
@property(nonatomic, strong) YBChrono * iinitChrono;
@property(nonatomic, strong) YBChrono * backgroundInfinity;
@property(nonatomic, strong) NSString * lastServiceSent;

// Infinity initial variables
@property(nonatomic, strong) NSString * startScreenName;
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> * startDimensions;

// Will send listeners
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendInitListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendStartListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendJoinListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendPauseListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendResumeListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendSeekListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendBufferListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendErrorListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendStopListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendPingListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendVideoEventListeners;

@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdInitListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdStartListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdJoinListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdPauseListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdResumeListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdBufferListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdStopListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendClickListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdErrorListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdManifestListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdBreakStartListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdBreakStopListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdQuartileListeners;

@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendSessionStartListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendSessionStopListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendSessionNavListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendSessionEventListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendSessionBeatListeners;

// Ad error variables
@property(nonatomic, strong) NSString * adErrorCode;
@property(nonatomic, strong) NSString * adErrorMessage;

//Ad Manifest
@property(nonatomic, strong) NSDictionary * adManifestParams;

//Infinity
@property(nonatomic, strong) YBInfinity * infinity;

// Property that gonna prevent the same error to be sent in less than x seconds
@property(nonatomic, strong) YBErrorHandler *errorHandler;

// Flag that will help management of the backgroundNotifications
@property Boolean isBackgroundListenerRegistered;
@end

@implementation YBPlugin

#pragma mark - Init
- (instancetype) initWithOptions:(YBOptions *) options {
    return [self initWithOptions:options andAdapter:nil];
}

- (instancetype) initWithOptions:(YBOptions *) options andAdapter:(YBPlayerAdapter *) adapter {
    return [self initWithOptions:options adapter:adapter andConfig:nil];
}

- (instancetype) initWithOptions:(nullable YBOptions *) options adapter:(nullable YBPlayerAdapter *) adapter andConfig:(nullable YBFastDataConfig*) fastConfig {
    self = [super init];
    if (self) {
        if (options == nil) {
            [YBLog warn:@"Options is nil"];
            options = [YBOptions new];
        };
        self.isBackgroundListenerRegistered = false;
        self.errorHandler = [[YBErrorHandler alloc] initWithSecondsToClean:5];
        self.playedPostrolls = 0;
        self.isInitiated = false;
        self.isPreloading = false;
        self.isStarted = false;
        self.isAdStarted = false;
        self.preloadChrono = [self createChrono];
        self.iinitChrono = [self createChrono];
        self.options = options;
        
        if (adapter != nil) {
            self.adapter = adapter;
        }
        
        __weak typeof(self) weakSelf = self;
        self.pingTimer = [self createTimerWithCallback:^(YBTimer *timer, long long diffTime) {
            [weakSelf sendPing:diffTime];
            
        } andInterval:5000];
        
        self.beatTimer = [self createBeatTimerWithCallback:^(YBTimer *timer, long long diffTime) {
            [weakSelf sendBeat:diffTime];
        } andInterval:30000];
        
        self.metadataTimer = [self createMetadataTimerWithCallback:^(YBTimer *timer, long long diffTime) {
            if ([weakSelf isExtraMetadataReady]) {
                
                if (weakSelf.adsAdapter == nil) {
                    [weakSelf startListener:nil];
                }
                
                if (weakSelf.adsAdapter != nil
                    && weakSelf.adsAdapter.flags.adBreakStarted
                    && ![[weakSelf getAdBreakPosition] isEqualToString:@"post"]) {
                    [weakSelf startListener:nil];
                }
                [timer stop];
            }
        } andInterval:5000];
        
        self.requestBuilder = [self createRequestBuilder];
        self.resourceTransform = [self createResourceTransform];
        self.cdnSwitchParser = [self createCdnSwitchParser];
        [self initViewTransform: fastConfig];
        
        self.lastServiceSent = nil;
        
        [self registerToBackgroundNotifications];
    }
    return self;
}

#pragma mark - Public method {

- (void)setAdapter:(YBPlayerAdapter *)adapter {
    [self removeAdapter: false];
    
    if (adapter != nil) {
        _adapter = adapter;
        adapter.plugin = self;
        [adapter addYouboraAdapterDelegate:self];
        [self registerToBackgroundNotifications];
    }else{
        [YBLog error:@"Adapter is null in setAdapter"];
    }
}

- (void) removeAdapter {
    [self removeAdapter:YES];
}

- (void) removeAdapter: (BOOL)shouldStopPings {
    if (self.adapter != nil) {
        [self.adapter dispose];
        
        self.adapter.plugin = nil;
        self.options.adsAfterStop = @0;
        
        [self.adapter removeYouboraAdapterDelegate:self];
        
        _adapter = nil;
        [self unregisterBackgroundNotifications];
    }
    
    if(shouldStopPings && self.adsAdapter == nil){
        [self fireStop];
    }
}

- (void)setAdsAdapter:(YBPlayerAdapter *)adsAdapter {
    if (adsAdapter == nil) {
        [YBLog error:@"Adapter is nil in setAdsAdapter"];
    } else if (adsAdapter.plugin != nil) {
        [YBLog warn:@"Adapters can only be added to a single plugin"];
    } else {
        [self removeAdsAdapter: false];
        
        _adsAdapter = adsAdapter;
        adsAdapter.plugin = self;
        
        [adsAdapter addYouboraAdapterDelegate:self];
    }
}

- (void) removeAdsAdapter {
    [self removeAdsAdapter:YES];
}

- (void) removeAdsAdapter: (BOOL)shouldStopPings {
    if (self.adsAdapter != nil) {
        [self.adsAdapter dispose];
        
        self.adsAdapter.plugin = nil;
        
        [self.adsAdapter removeYouboraAdapterDelegate:self];
        
        _adsAdapter = nil;
    }
    
    if(shouldStopPings && self.adapter == nil){
        [self fireStop];
    }
}

- (YBInfinity *) getInfinity {
    if (!self.infinity) {
        self.infinity = [[YBInfinity alloc] init];
        self.infinity.delegate = self;
        self.infinity.viewTransform = self.viewTransform;
    }
    
    return self.infinity;
}

- (void) disable {
    self.options.enabled = false;
}

- (void) enable {
    self.options.enabled = true;
}

- (void) firePreloadBegin {
    if (!self.isPreloading) {
        self.isPreloading = true;
        [self.preloadChrono start];
    }
}

- (void) firePreloadEnd {
    if (self.isPreloading) {
        self.isPreloading = false;
        [self.preloadChrono stop];
    }
}

- (void) fireInit {
    [self fireInitWithParams:nil];
}

- (void) fireInitWithParams:(NSDictionary<NSString *, NSString *> *) params {
    if (!self.isInitiated && !self.isStarted) {
        [self.viewTransform nextView];
        [self initComm];
        [self startPings];
        [self startMetadataTimer];
        
        self.isInitiated = true;
        [self.iinitChrono start];
        
        [self sendInit:params];
        
        [self startResourceParsing];
        
        if (self.adErrorMessage != nil && self.adErrorCode != nil) {
            if (self.adsAdapter != nil) {
                [self.adsAdapter fireFatalErrorWithMessage:self.adErrorMessage code:self.adErrorCode andMetadata:nil];
                self.adErrorMessage = nil;
                self.adErrorCode = nil;
            }
        }
        
    }
}

- (void) fireErrorWithParams:(NSDictionary<NSString *, NSString *> *) params {
    NSString *msg = params[YBConstantsErrorParams.message];
    NSString *code = params[YBConstantsErrorParams.code];
    
    if (![self.errorHandler isNewErrorWithMessage:msg code:code]) { return; }
    
    [self sendError:[YBYouboraUtils buildErrorParams:params]];
}

- (void) fireErrorWithMessage:(NSString *) msg code:(NSString *) code andErrorMetadata:(NSString *) errorMetadata {
    // Ignore error because this error is on the list to be ignored
    if ([YBYouboraUtils containsStringWithArray:self.options.ignoreErrors value:code]) {
        return;
    }
    
    if (![self.errorHandler isNewErrorWithMessage:msg code:code]) { return; }
    
    [self sendError:[YBYouboraUtils buildErrorParamsWithMessage:msg code:code metadata:errorMetadata andLevel:@"error"]];
    
    // Fire stop case the error was found in the fatal errors
    if ([YBYouboraUtils containsStringWithArray:self.options.fatalErrors value:code]) {
        [self fireStop];
    }
}

- (void) fireFatalErrorWithMessage:(NSString *) msg code:(NSString *) code andErrorMetadata:(NSString *) errorMetadata andException:(nullable NSException*) exception{
    // Ignore error because this error is on the list to be ignored
    if ([YBYouboraUtils containsStringWithArray:self.options.ignoreErrors value:code]) {
        return;
    }
    
    if(self.adapter != nil){
        if(exception != nil){
            [self.adapter fireErrorWithMessage:msg code:code andMetadata:errorMetadata andException:exception];
        }else{
            [self.adapter fireErrorWithMessage:msg code:code andMetadata:errorMetadata];
        }
    }else{
        [self fireErrorWithParams:[YBYouboraUtils buildErrorParamsWithMessage:msg code:code metadata:errorMetadata andLevel:@""]];
    }
    
    // Don't send stop case non fatal
    if (![YBYouboraUtils containsStringWithArray:self.options.nonFatalErrors value:code]) {
        [self fireStop];
    }
    
}

- (void) fireStop {
    if (self.adapter != nil && self.adapter.flags.started) {
        [self.adapter fireStop];
    } else {
        [self fireStop:nil];
    }
}

- (void) fireStop:(nullable NSDictionary<NSString *, NSString *> *) params{
    if(self.isInitiated){
        [self stopListener:params];
    }
}

- (void) fireOfflineEvents{
    [self fireOfflineEvents:nil];
}

- (void) fireOfflineEvents: (nullable NSDictionary<NSString *, NSString *> *) params{
    if(params == nil)
        params = [[NSDictionary alloc] init];
    
    if(self.options.offline){
        [YBLog error:@"To send offline events, offline option must be disabled"];
        return;
    }
    
    if(self.isInitiated){
        [YBLog error:@"fireOfflineEvents must be called before fireInit method"];
        return;
    }
    
    if(self.adapter != nil && self.adapter.flags != nil && self.adapter.flags.started &&
       self.adsAdapter != nil && self.adsAdapter.flags != nil && self.adsAdapter.flags.started){
        [YBLog error:@"Adapters have to be stopped"];
        return;
    }
    [self initComm];
    /*self.comm = [self createCommunication];
     [self.comm addTransform:self.viewTransform];*/
    
    YBEventDataSource *dataSource = [YBEventDataSource new];
    [dataSource allEventsWithCompletion:^(NSArray* events){
        if(events != nil && events.count == 0){
            [YBLog debug:@"No offline events, skipping..."];
            return;
        }
        [dataSource lastIdWithCompletion:^(NSInteger lastId){
            for(NSInteger k = lastId ; k >= 0  ; k--){
                [dataSource eventsWithOfflineId: k completion:^(NSArray * events){
                    if(events == nil){
                        return;
                    }
                    if(events.count == 0){
                        return;
                    }
                    //YBEvent *event = events[0];
                    [self sendOfflineEventsWithEventsString:[self generateOfflineJsonStringWithEvents:events]
                                               andOfflineId: [NSNumber numberWithInteger:((YBEvent *)events[0]).offlineId]];
                }];
            }
        }];
    }];
}

- (NSString*) generateOfflineJsonStringWithEvents:(NSArray*)events{
    NSString *jsonString = @"[";
    NSString *stringFormat = @"%@,%@";
    for(YBEvent *event in events){
        stringFormat = [jsonString isEqualToString:@"["] ? @"%@%@" : @"%@,%@";
        jsonString = [NSString stringWithFormat:stringFormat, jsonString, event.jsonEvents];
    }
    return [NSString stringWithFormat:@"%@]",jsonString];
}

- (void) sendOfflineEventsWithEventsString:(NSString *)events andOfflineId:(NSNumber *)offlineId{
    NSMutableDictionary<NSString*, id> *listenerParams = [[NSMutableDictionary alloc] init];
    [listenerParams setValue:offlineId forKey: YBConstants.successListenerOfflineId];
    YBRequestSuccessBlock successListener = ^(NSData * data, NSURLResponse * response,  NSDictionary<NSString *, id>* listenerParams) {
        __block YBEventDataSource* dataSource = [YBEventDataSource new];
        [dataSource deleteEventsWithOfflineId:[offlineId integerValue] completion:^{
            [YBLog debug:@"Offline events deleted"];
        }];
    };
    [self sendWithCallbacks:nil service: YBConstantsYouboraService.offline andParams:nil andMethod:YouboraHTTPMethodPost andBody:events withSuccessListener:successListener andSuccessListenerParams:listenerParams];
    /*NSMutableDictionary<NSString*, NSString*> *params = [[NSMutableDictionary alloc] init];
     params[@"events"] = events;
     params[@"offlineId"] = [offlineId stringValue];
     [self sendWithCallbacks:nil service:YouboraServiceOffline andParams:params];*/
}

- (void) initViewTransform:(YBFastDataConfig*)fastConfig {
    self.viewTransform = [self createViewTransform];
    
    [self.viewTransform addTranformDoneObserver:self andSelector:@selector(transformDone:)];
    [self.viewTransform begin: fastConfig];
    
}

// ------ INFO GETTERS ------
- (NSString *) getHost {
    return [YBYouboraUtils addProtocol:[YBYouboraUtils stripProtocol:self.options.host] https:self.options.httpSecure];
}

-(bool) isParseResource {
    return self.options.parseResource;
}

- (bool) isParseHls {
    return self.options.parseHls;
}

- (bool) isParseDASH {
    return self.options.parseDash;
}

- (bool) isParseCdnNode {
    return self.options.parseCdnNode;
}

- (bool) isParseLocationHeader {
    return self.options.parseLocationHeader;
}

- (NSArray<NSString *> *) getParseCdnNodeList {
    return self.options.parseCdnNodeList;
}

- (NSArray<NSString *> *) getExperimentIds{
    return self.options.experimentIds;
}

- (NSString *) getParseCdnNameHeader {
    return self.options.parseCdnNameHeader;
}

- (NSNumber *) getPlayhead {
    NSNumber * ph = nil;
    if (self.adapter != nil) {
        @try {
            ph = [self.adapter getPlayhead];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPlayhead"];
            [YBLog logException:exception];
        }
    }
    return [YBYouboraUtils parseNumber:ph orDefault:@0];
}

- (NSNumber *) getPlayrate {
    NSNumber * val = nil;
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getPlayrate];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPlayrate"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@1];
}

- (NSNumber *) getFramesPerSecond {
    NSNumber * val = self.options.contentFps;
    if (self.adapter != nil && val == nil) {
        @try {
            val = [self.adapter getFramesPerSecond];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getFramesPerSecond"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}


- (NSNumber *) getDroppedFrames {
    NSNumber * val = nil;
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getDroppedFrames];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getDroppedFrames"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *) getDuration {
    NSNumber * val = self.options.contentDuration;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getDuration];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getDuration"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *) getBitrate {
    NSNumber * val = self.options.contentBitrate;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getBitrate];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getBitrate"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@(-1)];
}

- (NSNumber *) getTotalBytes {
    if (![self isToSendTotalBytes]) { return nil;}
    
    NSNumber * val = self.options.contentTotalBytes;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getTotalBytes];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getBitrate"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@(-1)];
}

- (Boolean) isToSendTotalBytes {
    NSNumber *sendTotalBytes = self.options.sendTotalBytes;
    
    if (!sendTotalBytes) { return  false; }
    
    return [sendTotalBytes isEqualToNumber: [NSNumber numberWithBool:true]];
}

- (NSNumber *) getThroughput {
    NSNumber * val = self.options.contentThroughput;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getThroughput];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getThroughput"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@(-1)];
}

- (NSString *) getRendition {
    NSString * val = self.options.contentRendition;
    if ((val == nil || val.length == 0) && self.adapter != nil) {
        @try {
            val = [self.adapter getRendition];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getRendition"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getTitle {
    NSString * val = self.options.contentTitle;
    if ((val == nil || val.length == 0) && self.adapter != nil) {
        @try {
            val = [self.adapter getTitle];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getTitle"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getTitle2 {
    NSString * val = self.options.program;
    if ((val == nil || val.length == 0) && self.adapter != nil) {
        @try {
            val = [self.adapter getProgram];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getTitle2"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getProgram {
    NSString * val = self.options.program;
    if ((val == nil || val.length == 0) && self.adapter != nil) {
        @try {
            val = [self.adapter getProgram];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getProgram"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSValue *) getIsLive {
    NSValue * val = self.options.contentIsLive;
    if ((val == nil) && self.adapter != nil) {
        @try {
            val = [self.adapter getIsLive];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getIsLive"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getResource {
    return [self getOriginalResource];
}

- (NSString *) getParsedResource {
    NSString * val = nil;
    if (![self.resourceTransform isBlocking:nil]) {
        val = [self.resourceTransform getResource];
    }
    val = [self.adapter getURLToParse] ? [self.adapter getURLToParse] : val;
    return [val isEqualToString:[self getOriginalResource]] ? nil : val;
}

- (NSString *) getOriginalResource {
    NSString * val = self.options.contentResource;
    
    if ((val == nil || val.length == 0) && self.adapter != nil) {
        @try {
            val = [self.adapter getResource];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getResource"];
            [YBLog logException:exception];
        }
    }
    
    if (val.length == 0) {
        val = nil;
    }
    
    return val;
}

- (NSString *) getStreamingProtocol {
    if (self.options.contentStreamingProtocol != nil) {
        return [self.options.contentStreamingProtocol uppercaseString];
    }
    return nil;
}

- (NSString *)getTransportFormat {
    if (self.options.contentTransportFormat != nil) {
        return [self.options.contentTransportFormat uppercaseString];
    }
    
    NSString *autoDectectedTransportFormat = [self.resourceTransform getTransportFormat];
    
    if (autoDectectedTransportFormat) {
        return [autoDectectedTransportFormat uppercaseString];
    }
    
    return nil;
}

- (NSString *)getTransactionCode {
    return self.options.contentTransactionCode;
}

- (NSString *) getContentMetadata {
    return [YBYouboraUtils stringifyDictionary:self.options.contentMetadata];
}

- (NSString *) getContentPackage {
    return self.options.contentPackage;
}

- (NSString *) getContentSaga {
    return self.options.contentSaga;
}

- (NSString *) getContentTvShow {
    return self.options.contentTvShow;
}

- (NSString *) getContentSeason {
    return self.options.contentSeason;
}

- (NSString *) getContentEpisodeTitle {
    return self.options.contentEpisodeTitle;
}

- (NSString *) getContentChannel {
    return self.options.contentChannel;
}

- (NSString *) getContentId {
    return self.options.contentId;
}

- (NSString *) getContentImdbId {
    return self.options.contentImdbId;
}

- (NSString *) getContentGracenoteId {
    return self.options.contentGracenoteId;
}

- (NSString *) getContentType {
    return self.options.contentType;
}

- (NSString *) getContentGenre {
    return self.options.contentGenre;
}

- (NSString *) getContentLanguage {
    return self.options.contentLanguage;
}

- (NSString *) getContentSubtitles {
    return self.options.contentSubtitles;
}

- (NSString *) getContentContractedResolution {
    return self.options.contentContractedResolution;
}

- (NSString *) getContentCost {
    return self.options.contentCost;
}

- (NSString *) getContentPrice {
    return self.options.contentPrice;
}

- (NSString *) getContentPlaybackType {
    NSString * val = self.options.contentPlaybackType;
    
    if (self.adapter != nil && val == nil) {
        @try {
            if (self.options.offline) {
                val = @"Offline";
            } else {
                if ([self getIsLive] != nil) {
                    val = [[self getIsLive] isEqualToValue:@YES] ? YBConstantsRequest.live : @"VoD";
                }
            }
        } @catch (NSException *exception) {
            [YBLog debug:@"An error occurred while calling getContentPlaybackType"];
            [YBLog logException:exception];
        }
    }
    return val;
}

- (NSString *) getContentDrm {
    return self.options.contentDrm;
}

- (NSString *) getContentEncodingVideoCodec {
    NSString *videoCodec = self.options.contentEncodingVideoCodec;
    
    if (!videoCodec && self.adapter) {
        return [self.adapter getVideoCodec];
    }
    
    return videoCodec;
}

- (NSString *) getContentEncodingAudioCodec {
    NSString *audioCodec = self.options.contentEncodingAudioCodec;
    
    if (!audioCodec && self.adapter) {
        return [self.adapter getAudioCodec];
    }
    
    return audioCodec;
}

- (NSString *) getContentEncodingCodecSettings {
    return [YBYouboraUtils stringifyDictionary:self.options.contentEncodingCodecSettings];
}

- (NSString *) getContentEncodingCodecProfile {
    return self.options.contentEncodingCodecProfile;
}

- (NSString *) getContentEncodingContainerFormat {
    return self.options.contentEncodingContainerFormat;
}

- (NSString *) getPlayerVersion {
    NSString * val = nil;
    
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getPlayerVersion];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPlayerVersion"];
            [YBLog logException:exception];
        }
    }
    
    if (val == nil) {
        val = @"";
    }
    
    return val;
}

- (NSString *) getPlayerName {
    NSString * val = nil;
    
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getPlayerName];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPlayerName"];
            [YBLog logException:exception];
        }
    }
    
    if (val == nil) {
        val = @"";
    }
    
    return val;
}

- (NSString *) getCdn {
    NSString * cdn = [self.cdnSwitchParser getLastKnownCdn];
    
    if (cdn) { return cdn; }
    
    if (![self.resourceTransform isBlocking:nil]) {
        cdn = [self.resourceTransform getCdnName];
    }
    
    if (cdn) { return cdn; }
    
    return self.options.contentCdn;
}

- (NSNumber *)getLatency{
    NSNumber * val = nil;
    NSNumber *isLive = self.options.contentIsLive;
    
    if (self.adapter != nil && [isLive boolValue]) {
        @try {
            val = [self.adapter getLatency];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getLatency"];
            [YBLog logException:exception];
        }
    }
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *)getPacketLost{
    NSNumber * val = nil;
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getPacketLost];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPacketLost"];
            [YBLog logException:exception];
        }
    }
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *)getPacketSent{
    NSNumber * val = nil;
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getPacketSent];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPacketSent"];
            [YBLog logException:exception];
        }
    }
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSString *) getPluginVersion {
    NSString * ver = [self getAdapterVersion];
    if (ver == nil) {
        ver = [YBConstants.youboraLibVersion stringByAppendingString:@"-adapterless-ios"];
    }
    
    return ver;
}

- (NSString *) getAdapterVersion {
    NSString * val = nil;
    
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getVersion];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getVersion"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSValue *)getAdBlockerDetected {
    return self.options.adBlockerDetected;
}

- (NSString *) getExtraparam1 {
    return self.options.extraparam1;
}

- (NSString *) getExtraparam2 {
    return self.options.extraparam2;
}

- (NSString *) getExtraparam3 {
    return self.options.extraparam3;
}

- (NSString *) getExtraparam4 {
    return self.options.extraparam4;
}

- (NSString *) getExtraparam5 {
    return self.options.extraparam5;
}

- (NSString *) getExtraparam6 {
    return self.options.extraparam6;
}

- (NSString *) getExtraparam7 {
    return self.options.extraparam7;
}

- (NSString *) getExtraparam8 {
    return self.options.extraparam8;
}

- (NSString *) getExtraparam9 {
    return self.options.extraparam9;
}

- (NSString *) getExtraparam10 {
    return self.options.extraparam10;
}

- (NSString *) getExtraparam11 {
    return self.options.extraparam11;
}

- (NSString *) getExtraparam12 {
    return self.options.extraparam12;
}

- (NSString *) getExtraparam13 {
    return self.options.extraparam13;
}

- (NSString *) getExtraparam14 {
    return self.options.extraparam14;
}

- (NSString *) getExtraparam15 {
    return self.options.extraparam15;
}

- (NSString *) getExtraparam16 {
    return self.options.extraparam16;
}

- (NSString *) getExtraparam17 {
    return self.options.extraparam17;
}

- (NSString *) getExtraparam18 {
    return self.options.extraparam18;
}

- (NSString *) getExtraparam19 {
    return self.options.extraparam19;
}

- (NSString *) getExtraparam20 {
    return self.options.extraparam20;
}

- (NSString *) getAdExtraparam1 {
    return self.options.adExtraparam1;
}

- (NSString *) getAdExtraparam2 {
    return self.options.adExtraparam2;
}

- (NSString *) getAdExtraparam3 {
    return self.options.adExtraparam3;
}

- (NSString *) getAdExtraparam4 {
    return self.options.adExtraparam4;
}

- (NSString *) getAdExtraparam5 {
    return self.options.adExtraparam5;
}

- (NSString *) getAdExtraparam6 {
    return self.options.adExtraparam6;
}

- (NSString *) getAdExtraparam7 {
    return self.options.adExtraparam7;
}

- (NSString *) getAdExtraparam8 {
    return self.options.adExtraparam8;
}

- (NSString *) getAdExtraparam9 {
    return self.options.adExtraparam9;
}

- (NSString *) getAdExtraparam10 {
    return self.options.adExtraparam10;
}

- (NSString *) getCustomDimension1 {
    return self.options.contentCustomDimension1;
}

- (NSString *) getCustomDimension2 {
    return self.options.contentCustomDimension2;
}

- (NSString *) getCustomDimension3 {
    return self.options.contentCustomDimension3;
}

- (NSString *) getCustomDimension4 {
    return self.options.contentCustomDimension4;
}

- (NSString *) getCustomDimension5 {
    return self.options.contentCustomDimension5;
}

- (NSString *) getCustomDimension6 {
    return self.options.contentCustomDimension6;
}

- (NSString *) getCustomDimension7 {
    return self.options.contentCustomDimension7;
}

- (NSString *) getCustomDimension8 {
    return self.options.contentCustomDimension8;
}

- (NSString *) getCustomDimension9 {
    return self.options.contentCustomDimension9;
}

- (NSString *) getCustomDimension10 {
    return self.options.contentCustomDimension10;
}

- (NSString *) getCustomDimension11 {
    return self.options.contentCustomDimension11;
}

- (NSString *) getCustomDimension12 {
    return self.options.contentCustomDimension12;
}

- (NSString *) getCustomDimension13 {
    return self.options.contentCustomDimension13;
}

- (NSString *) getCustomDimension14 {
    return self.options.contentCustomDimension14;
}

- (NSString *) getCustomDimension15 {
    return self.options.contentCustomDimension15;
}

- (NSString *) getCustomDimension16 {
    return self.options.contentCustomDimension16;
}

- (NSString *) getCustomDimension17 {
    return self.options.contentCustomDimension17;
}

- (NSString *) getCustomDimension18 {
    return self.options.contentCustomDimension18;
}

- (NSString *) getCustomDimension19 {
    return self.options.contentCustomDimension19;
}

- (NSString *) getCustomDimension20{
    return self.options.contentCustomDimension20;
}

- (NSString *) getContentCustomDimension1 {
    return self.options.contentCustomDimension1;
}

- (NSString *) getContentCustomDimension2 {
    return self.options.contentCustomDimension2;
}

- (NSString *) getContentCustomDimension3 {
    return self.options.contentCustomDimension3;
}

- (NSString *) getContentCustomDimension4 {
    return self.options.contentCustomDimension4;
}

- (NSString *) getContentCustomDimension5 {
    return self.options.contentCustomDimension5;
}

- (NSString *) getContentCustomDimension6 {
    return self.options.contentCustomDimension6;
}

- (NSString *) getContentCustomDimension7 {
    return self.options.contentCustomDimension7;
}

- (NSString *) getContentCustomDimension8 {
    return self.options.contentCustomDimension8;
}

- (NSString *) getContentCustomDimension9 {
    return self.options.contentCustomDimension9;
}

- (NSString *) getContentCustomDimension10 {
    return self.options.contentCustomDimension10;
}

- (NSString *) getContentCustomDimension11 {
    return self.options.contentCustomDimension11;
}

- (NSString *) getContentCustomDimension12 {
    return self.options.contentCustomDimension12;
}

- (NSString *) getContentCustomDimension13 {
    return self.options.contentCustomDimension13;
}

- (NSString *) getContentCustomDimension14 {
    return self.options.contentCustomDimension14;
}

- (NSString *) getContentCustomDimension15 {
    return self.options.contentCustomDimension15;
}

- (NSString *) getContentCustomDimension16 {
    return self.options.contentCustomDimension16;
}

- (NSString *) getContentCustomDimension17 {
    return self.options.contentCustomDimension17;
}

- (NSString *) getContentCustomDimension18 {
    return self.options.contentCustomDimension18;
}

- (NSString *) getContentCustomDimension19 {
    return self.options.contentCustomDimension19;
}

- (NSString *) getContentCustomDimension20{
    return self.options.contentCustomDimension20;
}

- (NSString *)getCustomDimensions {
    return [YBYouboraUtils stringifyDictionary:self.options.contentCustomDimensions];
}

- (NSString *) getAdCustomDimension1 {
    return self.options.adCustomDimension1;
}

- (NSString *) getAdCustomDimension2 {
    return self.options.adCustomDimension2;
}

- (NSString *) getAdCustomDimension3 {
    return self.options.adCustomDimension3;
}

- (NSString *) getAdCustomDimension4 {
    return self.options.adCustomDimension4;
}

- (NSString *) getAdCustomDimension5 {
    return self.options.adCustomDimension5;
}

- (NSString *) getAdCustomDimension6 {
    return self.options.adCustomDimension6;
}

- (NSString *) getAdCustomDimension7 {
    return self.options.adCustomDimension7;
}

- (NSString *) getAdCustomDimension8 {
    return self.options.adCustomDimension8;
}

- (NSString *) getAdCustomDimension9 {
    return self.options.adCustomDimension9;
}

- (NSString *) getAdCustomDimension10 {
    return self.options.adCustomDimension10;
}

- (NSString *) getAdPlayerVersion {
    NSString * val = nil;
    if (self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getPlayerVersion];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getAdPlayerVersion"];
            [YBLog logException:exception];
        }
    }
    
    if (val == nil) {
        val = @"";
    }
    
    return val;
}

- (NSString *) getAdPosition {
    YBAdPosition pos =  YBAdPositionUnknown;
    
    if (self.adsAdapter != nil) {
        @try {
            pos = [self.adsAdapter getPosition];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getPosition"];
            [YBLog logException:exception];
        }
    }
    
    /*
     * If position is still unknown, we infer it from the adapter's flags
     * It's impossible to infer a postroll, but at least we differentiate between
     * pre and mid
     */
    if (pos == YBAdPositionUnknown && self.adapter != nil) {
        pos = self.adapter.flags.joined? YBAdPositionMid : YBAdPositionPre;
    }
    
    NSString * position;
    
    switch (pos) {
        case YBAdPositionPre:
            position = @"pre";
            break;
        case YBAdPositionMid:
            position = @"mid";
            break;
        case YBAdPositionPost:
            position = @"post";
            break;
        case YBAdPositionUnknown:
        default:
            position = @"unknown";
            break;
    }
    
    return position;
}

- (NSNumber *) getAdPlayhead {
    NSNumber * ph = nil;
    if (self.adsAdapter != nil) {
        @try {
            ph = [self.adsAdapter getPlayhead];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getPlayhead"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:ph orDefault:@0];
}

- (NSNumber *) getAdDuration {
    NSNumber * val = nil;
    if (self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getDuration];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getDuration"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *) getAdBitrate {
    NSNumber * br = nil;
    if (self.adsAdapter != nil) {
        @try {
            br = [self.adsAdapter getBitrate];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getBitrate"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:br orDefault:@(-1)];
}

- (NSString *) getAdCampaign {
    return self.options.adCampaign;
}

- (NSString *) getAdTitle {
    NSString * val = self.options.adTitle;
    if ((val == nil || val.length == 0) && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getTitle];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getTitle"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getAdResource {
    NSString * val = self.options.adResource;
    if ((val == nil || val.length == 0) && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getResource];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdResource"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getAdAdapterVersion {
    NSString * val = nil;
    if (self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getVersion];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdAdapterVersion"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getAdInsertionType {
    NSString * val = nil;
    if (self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdInsertionType];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdInsertionType"];
            [YBLog logException:exception];
        }
    }
    return val;
}

- (NSString *) getAdMetadata {
    return [YBYouboraUtils stringifyDictionary:self.options.adMetadata];
}

- (nullable NSString *) getAdGivenBreaks {
    NSNumber * val = self.options.adGivenBreaks;
    if (val == nil && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdGivenBreaks];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdGivenBreaks"];
            [YBLog logException:exception];
        }
    }
    
    return val != nil ? [val stringValue] : nil;
}

- (nullable NSString *) getAdExpectedBreaks {
    NSNumber * val = self.options.adExpectedBreaks;
    
    if (val == nil && self.options.adExpectedPattern != nil) {
        int totalBreaks = [self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionPre] != nil ? ((int)[[self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionPre] count]) : 0;
        totalBreaks += [self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionMid] != nil ? ((int)[[self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionMid] count]) : 0;
        totalBreaks += [self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionPost] != nil ? ((int)[[self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionPost] count]) : 0;
        
        val = [NSNumber numberWithInt:totalBreaks];
    } else if (self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdExpectedBreaks];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdExpectedBreaks"];
            [YBLog logException:exception];
        }
    }
    
    return val != nil ? [val stringValue] : nil;
}

- (nullable NSString *) getAdExpectedPattern {
    NSDictionary * val = self.options.adExpectedPattern;
    if (val == nil && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdExpectedPattern];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdExpectedPattern"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils stringifyDictionary:val];
}

- (nullable NSString *) getAdBreaksTime {
    NSArray * val = self.options.adBreaksTime;
    
    if (val == nil && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdBreaksTime];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdBreaksTime"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils stringifyList:val];
}

- (NSString *) getAdGivenAds {
    NSNumber * val = self.options.adGivenAds;
    if (val == nil && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getGivenAds];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdGivenAds"];
            [YBLog logException:exception];
        }
    }
    
    return val != nil ? [val stringValue] : nil;
}

- (NSString *) getAdBreakNumber {
    return self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
}

- (NSString *) getAdBreakPosition {
    return [self getAdPosition];
}

- (NSString *) getAdViewedDuration {
    NSNumber * val = nil;
    if (self.adsAdapter != nil) {
        @try {
            long long summatory = 0;
            for (YBChrono *chrono in self.adsAdapter.chronos.adViewedPeriods) {
                summatory = summatory + [chrono getDeltaTime:false];
            }
            val = [NSNumber numberWithLongLong:summatory];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad isAdSkippable"];
            [YBLog logException:exception];
        }
    }
    return val != nil ? [val stringValue] : nil;
}

- (NSString *) getAdViewability {
    NSNumber * val = nil;
    if (self.adsAdapter != nil) {
        @try {
            long long biggestValue = 0;
            for (YBChrono *chrono in self.adsAdapter.chronos.adViewedPeriods) {
                biggestValue = MAX([chrono getDeltaTime:false], biggestValue);
            }
            val = [NSNumber numberWithLongLong:(biggestValue)];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad isAdSkippable"];
            [YBLog logException:exception];
        }
    }
    return val != nil ? [val stringValue] : nil;
}

- (NSValue *) isAdSkippable {
    if (self.adsAdapter != nil) {
        @try {
            return [self.adsAdapter isSkippable];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad isAdSkippable"];
            [YBLog logException:exception];
        }
    }
    return false;
}

- (NSString *) getExpectedAds {
    NSNumber * val = nil;
    
    @try {
        if (self.adsAdapter != nil) {
            if (self.options.adExpectedPattern != nil && [self getAdPosition]) {
                NSMutableArray * list = [NSMutableArray arrayWithArray:[self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionPre]];
                [list addObjectsFromArray: [self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionMid]];
                [list addObjectsFromArray: [self.options.adExpectedPattern objectForKey:YBOptionKeys.adPositionPost]];
                if ([list count] > 0) {
                    int position = [[self.adsAdapter getAdBreakNumber] intValue] - 1;
                    if (position > [list count] - 1) {
                        position = (int)[list count] - 1;
                    }
                    val = list[position];
                }
            } else {
                val = [self.adsAdapter getExpectedAds];
            }
        }
    } @catch (NSException *exception) {
        [YBLog warn:@"An error occurred while calling ad getExpectedAds"];
        [YBLog logException:exception];
    }
    
    return val != nil ? [val stringValue] : nil;
}

- (NSValue *) getAdsExpected {
    return ([self getAdExpectedPattern] != nil || [self getAdGivenAds] != nil) ? @true : @false;
}

- (NSString *) getAdCreativeId {
    NSString * val = self.options.adCreativeId;
    if ((val == nil || val.length == 0) && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdCreativeId];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdCreativeId"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getAdProvider {
    NSString * val = self.options.adProvider;
    if ((val == nil || val.length == 0) && self.adsAdapter != nil) {
        @try {
            val = [self.adsAdapter getAdProvider];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling ad getAdCreativeId"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getPluginInfo {
    
    NSMutableDictionary * info = [NSMutableDictionary dictionaryWithObject:YBConstants.youboraLibVersion forKey:@"lib"];
    
    NSString * adapterVersion = [self getAdapterVersion];
    if (adapterVersion) {
        info[@"adapter"] = adapterVersion;
    }
    
    NSString * adAdapterVersion = [self getAdAdapterVersion];
    if (adAdapterVersion) {
        info[@"adAdapter"] = adAdapterVersion;
    }
    
    return [YBYouboraUtils stringifyDictionary:info];
}

- (NSString *) getIp {
    return self.options.networkIP;
}

- (NSString *) getIsp {
    return self.options.networkIsp;
}

- (NSString *) getConnectionType {
    return self.options.networkConnectionType;
}

- (NSValue *) getNetworkObfuscateIp {
    return self.options.userObfuscateIp;
}

- (NSString *) getDeviceCode {
    return self.options.deviceCode;
}

- (NSString *) getAccountCode {
    return self.options.accountCode;
}

- (NSString *) getUsername {
    return self.options.username;
}

- (NSString *) getUserType {
    return self.options.userType;
}

- (NSString *) getUserEmail {
    return self.options.userEmail;
}

- (NSString *) getAnonymousUser {
    return self.options.anonymousUser;
}

- (NSString *) getNodeHost {
    NSString * nodeHost = self.options.contentCdnNode;
    if (nodeHost == nil || [nodeHost length] == 0) {
        nodeHost = [self.resourceTransform getNodeHost];
    }
    return nodeHost;
}

- (NSString *) getNodeType {
    NSString * nodeType = self.options.contentCdnType;
    if (nodeType == nil || [nodeType length] == 0) {
        nodeType = [self.resourceTransform getNodeType];
    }
    return nodeType;
}

- (NSString *) getNodeTypeString {
    return [self.resourceTransform getNodeTypeString];
}

- (NSString *) getHouseholdId {
    NSString * val = nil;
    
    if (self.adapter != nil) {
        @try {
            val = [self.adapter getHouseholdId];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getHouseholdId"];
            [YBLog logException:exception];
        }
    }
    
    if (val == nil) {
        val = @"";
    }
    
    return val;
}

- (NSNumber *) getCdnTraffic {
    NSNumber * val = nil;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getCdnTraffic];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getCdnTraffic"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *) getP2PTraffic {
    NSNumber * val = nil;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getP2PTraffic];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getP2PTraffic"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSNumber *) getUploadTraffic {
    NSNumber * val = nil;
    if (val == nil && self.adapter != nil) {
        @try {
            val = [self.adapter getUploadTraffic];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getUploadTraffic"];
            [YBLog logException:exception];
        }
    }
    
    return [YBYouboraUtils parseNumber:val orDefault:@0];
}

- (NSValue *) getIsP2PEnabled {
    NSValue * val = nil;
    if ((val == nil) && self.adapter != nil) {
        @try {
            val = [self.adapter getIsP2PEnabled];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getIsP2PEnabled"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getNavContext {
    return [self getInfinity].navContext;
}

- (NSMutableArray *) getActiveSessions {
    return [self getInfinity].activeSessions;
}

- (NSString *) getLanguage {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *languageDict = [NSLocale componentsFromLocaleIdentifier:language];
    NSString *countryCode = [languageDict objectForKey:@"kCFLocaleCountryCodeKey"];
    NSString *languageCode = [languageDict objectForKey:@"kCFLocaleLanguageCodeKey"];
    return [NSString stringWithFormat:@"%@-%@",languageCode, countryCode];
}

- (NSValue *) getIsInfinity {
    return self.options.isInfinity;
}

- (NSString *) getParentId {
    if (![self getInfinity].flags.started) { return nil; }
    
    return [[self getInfinity] getSessionRoot];
}

- (NSString *) getLinkedViewId {
    return self.options.linkedViewId;
}

- (NSString *) getSmartSwitchConfigCode {
    return self.options.smartswitchConfigCode;
}

- (NSString *) getSmartSwitchGroupCode {
    return self.options.smartswitchGroupCode;
}

- (NSString *) getSmartSwitchContractCode {
    return self.options.smartswitchContractCode;
}

- (NSString *) getAppName {
    return self.options.appName;
}

- (NSString *) getAppReleaseVersion {
    return self.options.appReleaseVersion;
}

- (NSString *) getDeviceUUID {
    
    
    // Device UUID was defined by the customer so it should be returned
    if (self.options && !self.options.deviceIsAnonymous && self.options.deviceUUID) {
        return self.options.deviceUUID;
    }
#if TARGET_OS_IPHONE==1
    if (UIDevice.currentDevice.identifierForVendor && !self.options.deviceIsAnonymous) {
        return UIDevice.currentDevice.identifierForVendor.UUIDString;
    }
#endif
    
    return nil;
}

- (NSString *)getDeviceEDID {
    return self.options.deviceEDID;
}

- (NSString *) getVideoMetrics {
    NSString * metrics = [YBYouboraUtils stringifyDictionary:[self formatMetricsDict:self.options.contentMetrics]];
    
    if ((metrics == nil || metrics.length == 0) && self.adapter != nil) {
        @try {
            metrics = [YBYouboraUtils stringifyDictionary:[self.adapter getMetrics]];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getVideoMetrics"];
            [YBLog logException:exception];
        }
    }
    return metrics;
}

- (NSDictionary *) formatMetricsDict: (nullable NSDictionary *) origDict {
    if (origDict != nil) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary new];
        for(id key in origDict) {
            id value = origDict[key];
            NSMutableDictionary *valueDict = [NSMutableDictionary new];
            if (value != nil/* && [value isKindOfClass:[NSNumber class]]*/) {
                valueDict[@"value"] = value;
            }
            mutableDict[key] = valueDict;
        }
        return mutableDict;
    }
    return nil;
}

- (NSString *) getSessionMetrics {
    return [YBYouboraUtils stringifyDictionary: self.options.sessionMetrics];
}

// ------ CHRONOS ------
- (long long) getPreloadDuration {
    return [self.preloadChrono getDeltaTime:false];
}

- (long long) getInitDuration {
    return [self.iinitChrono getDeltaTime:false];
}

- (long long) getJoinDuration {
    if (self.isInitiated) {
        return [self getInitDuration];
    } else if (self.adapter != nil) {
        return [self.adapter.chronos.join getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getBufferDuration {
    if (self.adapter != nil) {
        return [self.adapter.chronos.buffer getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getSeekDuration {
    if (self.adapter != nil) {
        return [self.adapter.chronos.seek getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getPauseDuration {
    if (self.adapter != nil) {
        return [self.adapter.chronos.pause getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getAdJoinDuration {
    if (self.adsAdapter != nil) {
        return [self.adsAdapter.chronos.join getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getAdBufferDuration {
    if (self.adsAdapter != nil) {
        return [self.adsAdapter.chronos.buffer getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getAdPauseDuration {
    if (self.adsAdapter != nil) {
        return [self.adsAdapter.chronos.pause getDeltaTime:false];
    } else {
        return -1;
    }
}

- (long long) getAdTotalDuration {
    if (self.adsAdapter != nil) {
        return [self.adsAdapter.chronos.total getDeltaTime:false];
    } else {
        return -1;
    }
}
// Add listeners
- (void) addWillSendInitListener:(YBWillSendRequestBlock) listener {
    if (self.willSendInitListeners == nil)
        self.willSendInitListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendInitListeners addObject:listener];
}

/**
 * Adds a Start listener
 * @param listener to add
 */
- (void) addWillSendStartListener:(YBWillSendRequestBlock) listener {
    if (self.willSendStartListeners == nil)
        self.willSendStartListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendStartListeners addObject:listener];
}

/**
 * Adds a Join listener
 * @param listener to add
 */
- (void) addWillSendJoinListener:(YBWillSendRequestBlock) listener {
    if (self.willSendJoinListeners == nil)
        self.willSendJoinListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendJoinListeners addObject:listener];
}

/**
 * Adds a Pause listener
 * @param listener to add
 */
- (void) addWillSendPauseListener:(YBWillSendRequestBlock) listener {
    if (self.willSendPauseListeners == nil)
        self.willSendPauseListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendPauseListeners addObject:listener];
}

/**
 * Adds a Resume listener
 * @param listener to add
 */
- (void) addWillSendResumeListener:(YBWillSendRequestBlock) listener {
    if (self.willSendResumeListeners == nil)
        self.willSendResumeListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendResumeListeners addObject:listener];
}

/**
 * Adds a Seek listener
 * @param listener to add
 */
- (void) addWillSendSeekListener:(YBWillSendRequestBlock) listener {
    if (self.willSendSeekListeners == nil)
        self.willSendSeekListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendSeekListeners addObject:listener];
}

/**
 * Adds a Buffer listener
 * @param listener to add
 */
- (void) addWillSendBufferListener:(YBWillSendRequestBlock) listener {
    if (self.willSendBufferListeners == nil)
        self.willSendBufferListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendBufferListeners addObject:listener];
}

/**
 * Adds a Error listener
 * @param listener to add
 */
- (void) addWillSendErrorListener:(YBWillSendRequestBlock) listener {
    if (self.willSendErrorListeners == nil)
        self.willSendErrorListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendErrorListeners addObject:listener];
}

/**
 * Adds a Stop listener
 * @param listener to add
 */
- (void) addWillSendStopListener:(YBWillSendRequestBlock) listener {
    if (self.willSendStopListeners == nil)
        self.willSendStopListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendStopListeners addObject:listener];
}

/**
 * Adds a Ping listener
 * @param listener to add
 */
- (void) addWillSendPingListener:(YBWillSendRequestBlock) listener {
    if (self.willSendPingListeners == nil)
        self.willSendPingListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendPingListeners addObject:listener];
}

/**
 * Adds an ad Start listener
 * @param listener to add
 */
- (void) addWillSendAdInitListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdInitListeners == nil)
        self.willSendAdInitListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdInitListeners addObject:listener];
}

/**
 * Adds an ad Start listener
 * @param listener to add
 */
- (void) addWillSendAdStartListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdStartListeners == nil)
        self.willSendAdStartListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdStartListeners addObject:listener];
}

/**
 * Adds an ad Join listener
 * @param listener to add
 */
- (void) addWillSendAdJoinListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdJoinListeners == nil)
        self.willSendAdJoinListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdJoinListeners addObject:listener];
}

/**
 * Adds an ad Pause listener
 * @param listener to add
 */
- (void) addWillSendAdPauseListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdPauseListeners == nil)
        self.willSendAdPauseListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdPauseListeners addObject:listener];
}

/**
 * Adds an ad Resume listener
 * @param listener to add
 */
- (void) addWillSendAdResumeListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdResumeListeners == nil)
        self.willSendAdResumeListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdResumeListeners addObject:listener];
}

/**
 * Adds an ad Buffer listener
 * @param listener to add
 */
- (void) addWillSendAdBufferListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdBufferListeners == nil)
        self.willSendAdBufferListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdBufferListeners addObject:listener];
}

/**
 * Adds an ad Stop listener
 * @param listener to add
 */
- (void) addWillSendAdStopListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdStopListeners == nil)
        self.willSendAdStopListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdStopListeners addObject:listener];
}

/**
 * Adds a click listener, mostly for ads
 * @param listener to add
 */
- (void) addWillSendClickListener:(YBWillSendRequestBlock) listener {
    if (self.willSendClickListeners == nil)
        self.willSendClickListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendClickListeners addObject:listener];
}

- (void) addWillSendVideoEventListener:(YBWillSendRequestBlock) listener {
    if (self.willSendVideoEventListeners == nil)
        self.willSendVideoEventListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendVideoEventListeners addObject:listener];
}

/**
 * Adds a ad error listener
 * @param listener to add
 */
- (void) addWillSendAdErrorListener:(YBWillSendRequestBlock) listener{
    if(self.willSendAdErrorListeners == nil)
        self.willSendAdErrorListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdErrorListeners addObject:listener];
}

- (void) addWillSendAdManifestListener:(YBWillSendRequestBlock) listener {
    if(self.willSendAdManifestListeners == nil)
        self.willSendAdManifestListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdManifestListeners addObject:listener];
}

- (void) addWillSendAdBreakStartListener:(YBWillSendRequestBlock) listener {
    if(self.willSendAdBreakStartListeners == nil)
        self.willSendAdBreakStartListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdBreakStartListeners addObject:listener];
}

- (void) addWillSendAdBreakStopListener:(YBWillSendRequestBlock) listener {
    if(self.willSendAdBreakStopListeners == nil)
        self.willSendAdBreakStopListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdBreakStopListeners addObject:listener];
}

- (void) addWillSendQuartileListener:(YBWillSendRequestBlock) listener {
    if(self.willSendAdQuartileListeners == nil)
        self.willSendAdQuartileListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdQuartileListeners addObject:listener];
}

- (void) addOnWillSendSessionStartListener:(YBWillSendRequestBlock) listener{
    if(self.willSendSessionStartListeners == nil)
        self.willSendSessionStartListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendSessionStartListeners addObject:listener];
}

- (void) addOnWillSendSessionStopListener:(YBWillSendRequestBlock) listener{
    if(self.willSendSessionStopListeners == nil)
        self.willSendSessionStopListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendSessionStopListeners addObject:listener];
}

- (void) addOnWillSendSessionEventListener:(YBWillSendRequestBlock) listener{
    if(self.willSendSessionEventListeners == nil)
        self.willSendSessionEventListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendSessionEventListeners addObject:listener];
}

- (void) addOnWillSendSessionNavListener:(YBWillSendRequestBlock) listener{
    if(self.willSendSessionNavListeners == nil)
        self.willSendSessionNavListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendSessionNavListeners addObject:listener];
}

- (void) addOnWillSendSessionBeatListener:(YBWillSendRequestBlock) listener{
    if(self.willSendSessionBeatListeners == nil)
        self.willSendSessionBeatListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendSessionBeatListeners addObject:listener];
}

// Remove listeners
/**
 * Removes an Init listener
 * @param listener to remove
 */
- (void) removeWillSendInitListener:(YBWillSendRequestBlock) listener {
    if (self.willSendInitListeners != nil)
        [self.willSendInitListeners removeObject:listener];
}

/**
 * Removes a Start listener
 * @param listener to remove
 */
- (void) removeWillSendStartListener:(YBWillSendRequestBlock) listener {
    if (self.willSendStartListeners != nil)
        [self.willSendStartListeners removeObject:listener];
}

/**
 * Removes a Join listener
 * @param listener to remove
 */
- (void) removeWillSendJoinListener:(YBWillSendRequestBlock) listener {
    if (self.willSendJoinListeners != nil)
        [self.willSendJoinListeners removeObject:listener];
}

/**
 * Removes a Pause listener
 * @param listener to remove
 */
- (void) removeWillSendPauseListener:(YBWillSendRequestBlock) listener {
    if (self.willSendPauseListeners != nil)
        [self.willSendPauseListeners removeObject:listener];
}

/**
 * Removes a Resume listener
 * @param listener to remove
 */
- (void) removeWillSendResumeListener:(YBWillSendRequestBlock) listener {
    if (self.willSendResumeListeners != nil)
        [self.willSendResumeListeners removeObject:listener];
}

/**
 * Removes a Seek listener
 * @param listener to remove
 */
- (void) removeWillSendSeekListener:(YBWillSendRequestBlock) listener {
    if (self.willSendSeekListeners != nil)
        [self.willSendSeekListeners removeObject:listener];
}

/**
 * Removes a Buffer listener
 * @param listener to remove
 */
- (void) removeWillSendBufferListener:(YBWillSendRequestBlock) listener {
    if (self.willSendBufferListeners != nil)
        [self.willSendBufferListeners removeObject:listener];
}

/**
 * Removes a Error listener
 * @param listener to remove
 */
- (void) removeWillSendErrorListener:(YBWillSendRequestBlock) listener {
    if (self.willSendErrorListeners != nil)
        [self.willSendErrorListeners removeObject:listener];
}

/**
 * Removes a Stop listener
 * @param listener to remove
 */
- (void) removeWillSendStopListener:(YBWillSendRequestBlock) listener {
    if (self.willSendStopListeners != nil)
        [self.willSendStopListeners removeObject:listener];
}

/**
 * Removes a Ping listener
 * @param listener to remove
 */
- (void) removeWillSendPingListener:(YBWillSendRequestBlock) listener {
    if (self.willSendPingListeners != nil)
        [self.willSendPingListeners removeObject:listener];
}

/**
 * Removes an ad Start listener
 * @param listener to remove
 */
- (void) removeWillSendAdInitListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdInitListeners != nil)
        [self.willSendAdInitListeners removeObject:listener];
}

/**
 * Removes an ad Start listener
 * @param listener to remove
 */
- (void) removeWillSendAdStartListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdStartListeners != nil)
        [self.willSendAdStartListeners removeObject:listener];
}

/**
 * Removes an ad Join listener
 * @param listener to remove
 */
- (void) removeWillSendAdJoinListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdJoinListeners != nil)
        [self.willSendAdJoinListeners removeObject:listener];
}

/**
 * Removes an ad Pause listener
 * @param listener to remove
 */
- (void) removeWillSendAdPauseListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdPauseListeners != nil)
        [self.willSendAdPauseListeners removeObject:listener];
}

/**
 * Removes an ad Resume listener
 * @param listener to remove
 */
- (void) removeWillSendAdResumeListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdResumeListeners != nil)
        [self.willSendAdResumeListeners removeObject:listener];
}

/**
 * Removes an ad Buffer listener
 * @param listener to remove
 */
- (void) removeWillSendAdBufferListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdBufferListeners != nil)
        [self.willSendAdBufferListeners removeObject:listener];
}

/**
 * Removes an ad Stop listener
 * @param listener to remove
 */
- (void) removeWillSendAdStopListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdStopListeners != nil)
        [self.willSendAdStopListeners removeObject:listener];
}

/**
 * Removes an ad Click listener
 * @param listener to remove
 */
- (void) removeWillSendClickListener:(YBWillSendRequestBlock) listener {
    if (self.willSendClickListeners != nil)
        [self.willSendClickListeners removeObject:listener];
}

/**
 * Removes an ad Error listener
 * @param listener to remove
 */
- (void) removeWillSendAdErrorListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdErrorListeners != nil)
        [self.willSendAdErrorListeners removeObject:listener];
}

- (void) removeWillSendVideoEventListener:(YBWillSendRequestBlock) listener {
    if (self.willSendVideoEventListeners != nil)
        [self.willSendVideoEventListeners removeObject:listener];
}

- (void) removeOnWillSendSessionStart:(YBWillSendRequestBlock) listener {
    if (self.willSendSessionStartListeners != nil)
        [self.willSendSessionStartListeners removeObject:listener];
}

- (void) removeOnWillSendSessionStop:(YBWillSendRequestBlock) listener {
    if (self.willSendSessionStopListeners != nil)
        [self.willSendSessionStopListeners removeObject:listener];
}

- (void) removeOnWillSendSessionNav:(YBWillSendRequestBlock) listener {
    if (self.willSendSessionNavListeners != nil)
        [self.willSendSessionNavListeners removeObject:listener];
}

- (void) removeOnWillSendSessionEvent:(YBWillSendRequestBlock) listener {
    if (self.willSendSessionEventListeners != nil)
        [self.willSendSessionEventListeners removeObject:listener];
}

- (void) removeOnWillSendSessionBeat:(YBWillSendRequestBlock) listener {
    if (self.willSendSessionBeatListeners != nil)
        [self.willSendSessionBeatListeners removeObject:listener];
}

- (void) removeWillSendAdManifestListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdManifestListeners != nil)
        [self.willSendAdManifestListeners removeObject:listener];
}

- (void) removeWillSendAdBreakStartListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdBreakStartListeners != nil)
        [self.willSendAdBreakStartListeners removeObject:listener];
}

- (void) removeWillSendAdBreakStopListener:(YBWillSendRequestBlock) listener{
    if (self.willSendAdBreakStopListeners != nil)
        [self.willSendAdBreakStopListeners removeObject:listener];
}

- (void) removeWillSendQuartileListener:(YBWillSendRequestBlock) listener {
    if (self.willSendAdQuartileListeners != nil)
        [self.willSendAdQuartileListeners removeObject:listener];
}

#pragma mark - Private methods
- (YBChrono *) createChrono {
    return [YBChrono new];
}

- (YBTimer *) createTimerWithCallback:(TimerCallback)callback andInterval:(long) interval {
    return [[YBTimer alloc] initWithCallback:callback andInterval:interval];
}

- (YBTimer *) createBeatTimerWithCallback:(TimerCallback)callback andInterval:(long) interval {
    return [[YBTimer alloc] initWithCallback:callback andInterval:interval];
}

- (YBTimer *) createMetadataTimerWithCallback:(TimerCallback)callback andInterval:(long) interval {
    return [[YBTimer alloc] initWithCallback:callback andInterval:interval];
}

- (YBRequestBuilder *) createRequestBuilder {
    return [[YBRequestBuilder alloc] initWithPlugin:self];
}

- (YBResourceTransform *) createResourceTransform {
    return [[YBResourceTransform alloc] initWithPlugin:self];
}

-(YBCdnSwitchParser*) createCdnSwitchParser {
    return [[YBCdnSwitchParser alloc] initWithIsCdnSwitchHeader:self.options.cdnSwitchHeader andCdnTTL:self.options.cdnTTL];
}

-(void)startCdnSwitch {
    NSString *resource = [self getParsedResource] ? [self getParsedResource] : [self getOriginalResource];
    [self.cdnSwitchParser start:resource];
}

- (YBViewTransform *) createViewTransform {
    return [[YBViewTransform alloc] initWithPlugin:self];
}

- (YBOfflineTransform *) createOfflineTransform{
    return [[YBOfflineTransform alloc] init];
}

- (YBRequest *) createRequestWithHost:(NSString *)host andService:(NSString *)service {
    return [[YBRequest alloc] initWithHost:host andService:service];
}

- (BOOL) isSessionExpired {
    int64_t timeInBackground = self.backgroundInfinity.stopTime - self.backgroundInfinity.startTime;
    
    return (timeInBackground/1000) >= self.viewTransform.fastDataConfig.expirationTime.longLongValue;
}

- (YBCommunication *) createCommunication {
    return [YBCommunication new];
}

- (YBFlowTransform *) createFlowTransform {
    return [YBFlowTransform new];
}

- (YBTimestampLastSentTransform *) createLastSentTransform {
    return [YBTimestampLastSentTransform new];
}

- (void) reset {
    [self stopPings];
    [self.cdnSwitchParser invalidate];
    
    self.resourceTransform = [self createResourceTransform];
    self.isInitiated = false;
    self.isPreloading = false;
    self.isStarted = false;
    self.isAdStarted = false;
    
    self.adErrorCode = nil;
    self.adErrorMessage = nil;
    
    [self.preloadChrono reset];
    [self.iinitChrono reset];
}

- (void) sendWithCallbacks:(NSArray<YBWillSendRequestBlock> *) callbacks service:(NSString *) service andParams:(NSMutableDictionary<NSString *, NSString *> *) params {
    [self sendWithCallbacks:callbacks service:service andParams:params andMethod:YouboraHTTPMethodGet andBody:nil withSuccessListener:nil andSuccessListenerParams:nil];
    
}

- (void) sendWithCallbacks:(NSArray<YBWillSendRequestBlock> *) callbacks service:(NSString *) service andParams:(NSMutableDictionary<NSString *, NSString *> *) params andMethod:(NSString*) method andBody:(NSString*) body withSuccessListener:(YBRequestSuccessBlock) successListener andSuccessListenerParams:(NSMutableDictionary<NSString *, id> *) successListenerParams{
    
    params = [self.requestBuilder buildParams:params forService:service];
    
    if (callbacks != nil) {
        for (YBWillSendRequestBlock block in callbacks) {
            @try {
                block(service, self, params);
            } @catch (NSException *exception) {
                [YBLog error:@"Exception while calling willSendRequest"];
                [YBLog logException:exception];
            }
        }
    }
    
    if ([[self getIsLive] isEqualToValue:@YES]) {
        params[@"mediaDuration"] = nil;
        params[@"playhead"] = nil;
    }
    
    if (self.comm != nil && params != nil && self.options.enabled) {
        YBRequest * r = [self createRequestWithHost:nil andService:service];
        r.params = params;
        r.method = method;
        r.body = body;
        
        self.lastServiceSent = r.service;
        
        [self.comm sendRequest:r withCallback:successListener andListenerParams:successListenerParams];
    }
    
}

- (NSString *) jsonFromDictionary: (NSDictionary*) dictionary{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:(NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    if (! jsonData) {
        [YBLog error:@"SQLite database error: %@",error.localizedDescription];
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (void) initComm {
    //if (self.comm == nil) {
        self.comm = [self createCommunication];
        [self.comm addTransform:[self createFlowTransform]];
        [self.comm addTransform:[self createLastSentTransform]]; //Mostly used for Infinity, but may be interesting to use it along other requests
        
        [self.comm addTransform:self.resourceTransform];
        //[self.comm addTransform:[self createNqs6Transform]];
        
        if (self.options.offline) {
            [self.comm addTransform:[self createOfflineTransform]];
        } else {
            [self.comm addTransform:self.viewTransform];
        }
    //}
}

- (void) startResourceParsing {
    if (!self.resourceTransform.isBusy && !self.resourceTransform.isFinished) {
        NSString *adapterUrl;
        
        if (self.adapter) {
            adapterUrl = [self.adapter getURLToParse];
        }
        
        NSString *res = [YBResourceParserUtil
                         mergeWithResourseUrl:[self getOriginalResource]
                         adapterUrl:adapterUrl];
        
        if (res) {
            [self.resourceTransform begin:res userDefinedTransportFormat:self.options.contentTransportFormat];
        }
    }
}

- (NSString*) getDeviceInfoString {
    
    YBDeviceInfo *deviceInfo = [[YBDeviceInfo alloc] init];
    [deviceInfo setDeviceBrand:self.options.deviceBrand];
    [deviceInfo setDeviceModel:self.options.deviceModel];
    [deviceInfo setDeviceType:self.options.deviceType];
    [deviceInfo setDeviceCode:self.options.deviceCode];
    [deviceInfo setDeviceOsName:self.options.deviceOsName];
    [deviceInfo setDeviceOsVersion:self.options.deviceOsVersion];
    
    return [deviceInfo mapToJSONString];
}

- (void)registerToBackgroundNotifications {
#if TARGET_OS_IPHONE==1
    if (self.options.autoDetectBackground && !self.isBackgroundListenerRegistered) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(eventListenerDidReceivetoBack:)
                                                     name: UIApplicationDidEnterBackgroundNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(eventListenerDidReceiveToFore:)
                                                     name: UIApplicationWillEnterForegroundNotification
                                                   object: nil];
        self.isBackgroundListenerRegistered = true;
    }
#endif
}

-(void)unregisterBackgroundNotifications {
#if TARGET_OS_IPHONE==1
    if (![self getInfinity].flags.started) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        self.isBackgroundListenerRegistered = false;
    }
#endif
}

- (void) eventListenerDidReceivetoBack: (NSNotification*)uselessNotification {
    if(self.options.autoDetectBackground){
        if (self.adsAdapter != nil) {
            if (self.adsAdapter.flags.started || self.adsAdapter.flags.adInitiated) {
                [self.adsAdapter fireStop];
            }
            if (self.adsAdapter.flags.adBreakStarted) {
                [self.adsAdapter fireAdBreakStop];
            }
        }
        
        if (self.isInitiated && (self.adapter == nil || !self.adapter.flags.started)) {
            [self fireStop];
        } else if (self.adapter != nil && self.adapter.flags.started) {
            [self.adapter fireStop];
        }
    }
    
    if ([self getInfinity].flags.started) {
        long long time = [[[YBChrono alloc] init] now] - self.beatTimer.chrono.startTime;
        
        [self sendBeat:time];
        [self stopBeats];
        self.backgroundInfinity = [YBChrono new];
        [self.backgroundInfinity start];
    }
}

- (void) eventListenerDidReceiveToFore: (NSNotification*)uselessNotification {
    if (self.options != nil && self.backgroundInfinity) {
        [self.backgroundInfinity stop];
        if (![self isSessionExpired]) {
            long long time = [[[YBChrono alloc] init] now] - self.beatTimer.chrono.startTime;
            [self sendBeat:time];
            [self startBeats];
        } else {
            [[self getInfinity].flags reset];
            [self.viewTransform removeTranformDoneObserver:self];
            [self.comm removeTransform:self.viewTransform];
            [self initViewTransform: nil];
            [self.comm addTransform:self.viewTransform];
            [self getInfinity].viewTransform = self.viewTransform;
            [[self getInfinity] beginWithScreenName:self.startScreenName andDimensions:self.startDimensions];
        }
        self.backgroundInfinity = nil;
    }
}

// Listener methods
- (void) startListener:(NSDictionary<NSString *, NSString *> *) params {
    if ((!self.isInitiated && !self.isStarted) || [YBConstantsYouboraService.error isEqualToString:self.lastServiceSent]) {
        [self.viewTransform nextView];
        [self initComm];
        [self startPings];
    }
    
    [self startResourceParsing];
    
    if (self.isInitiated && self.adapter.flags.joined && !self.isStarted && [self isExtraMetadataReady]) {
        [self sendStart:params];
    }
    
    if (!self.isInitiated && !self.options.forceInit && [self getTitle] != nil
        && [self getResource] != nil && [self getIsLive] != nil
        && [self isLiveOrNotNullDuration] && !self.isStarted && [self isExtraMetadataReady]) {
        [self sendStart:params];
    } else if(!self.isInitiated) {
        [self fireInitWithParams:params];
    }
    
    if (self.adErrorMessage != nil && self.adErrorCode != nil) {
        if (self.adsAdapter != nil) {
            [self.adsAdapter fireFatalErrorWithMessage:self.adErrorMessage code:self.adErrorCode andMetadata:nil];
            self.adErrorMessage = nil;
            self.adErrorCode = nil;
        }
    }
}

- (void) joinListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adsAdapter == nil || !self.adsAdapter.flags.started) {
        if(self.isInitiated && !self.isStarted && !self.options.waitForMetadata) {
            if (self.adapter.flags.started == false)
                [self.adapter fireStart];
            else
                [self sendStart:@{}];
        }
        if (self.adsAdapter != nil && self.adsAdapter.flags.adBreakStarted) {
            [self.adsAdapter fireAdBreakStop];
        }
        [self sendJoin:params];
    } else {
        // Revert join state
        if (self.adapter != nil) {
            if (self.adapter.monitor != nil) {
                [self.adapter.monitor stop];
            }
            self.adapter.flags.joined = false;
            self.adapter.chronos.join.stopTime = 0;
        }
    }
}

- (void) pauseListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adapter != nil) {
        if (self.adapter.flags.buffering ||
            self.adapter.flags.seeking ||
            (self.adsAdapter != nil && self.adsAdapter.flags.started)) {
            [self.adapter.chronos.pause reset];
        }
    }
    
    [self sendPause:params];
}

- (void) resumeListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adsAdapter != nil && self.adsAdapter.flags.adBreakStarted) {
        [self.adsAdapter fireAdBreakStop];
    }
    [self sendResume:params];
}

- (void) seekBeginListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adapter != nil && self.adapter.flags.paused) {
        [self.adapter.chronos.pause reset];
    }
    [YBLog notice:@"Seek begin"];
}

- (void) seekEndListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendSeekEnd:params];
}

- (void) bufferBeginListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adapter != nil && self.adapter.flags.paused) {
        [self.adapter.chronos.pause reset];
    }
    
    [YBLog notice:@"Buffer begin"];
}

- (void) bufferEndListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendBufferEmd:params];
}

- (void) errorListener:(NSDictionary<NSString *, NSString *> *) params {
    
    BOOL isFatal = [@"fatal" isEqualToString:params[@"errorLevel"]];
    
    if (self.comm == nil) {
        [self initComm];
    }
    //Moved to sendError
    //[self startResourceParsing];
    
    [self sendError:params];
    
    if (isFatal) {
        [self reset];
    }
}

- (void) videoEventListener:(NSDictionary<NSString *, NSString*> *) params {    
    NSMutableDictionary<NSString *, NSString *> *params2 = [params mutableCopy];
    if (params2[@"dimensions"] != nil && [params2[@"dimensions"] isKindOfClass:[NSDictionary class]]) {
        params2[@"dimensions"] = [YBYouboraUtils stringifyDictionary:(NSDictionary *)params2[@"dimensions"]];
    }
    if (params2[@"values"] && [params2[@"values"] isKindOfClass:[NSDictionary class]]) {
        params2[@"values"] = [YBYouboraUtils stringifyDictionary:(NSDictionary *)params2[@"values"]];
    }
    
    
    [self sendVideoEvent:params2];
}

- (void) stopListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adsAdapter != nil && self.adsAdapter.flags.adBreakStarted) {
        [self.adsAdapter fireAdBreakStop];
    }
    [self sendStop:params];
    [self reset];
}

- (BOOL)isStopReady {
    double lastMediaDuration = [self.requestBuilder.lastSent[YBConstantsRequest.mediaDuration] doubleValue];
    // this solution is only for the case of:
    if (!self.requestBuilder.lastSent[YBConstantsRequest.live] // VOD, live have no postrolls
        && self.adsAdapter != nil // having ads adapter connected
        && self.adapter != nil // playhead close to the end of the content (or 0 because is already restarted)
        && (![self getPlayhead] || [self getPlayhead].doubleValue >= lastMediaDuration - 1)) {
        int expectedPostrolls = 0;
        NSDictionary * pat = self.options.adExpectedPattern;
        NSArray *breaks = self.requestBuilder.lastSent[YBConstantsRequest.breaksTime];
        NSString *str = [breaks description];
        if (!breaks) { str = [self getAdBreaksTime]; }
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[] "];
        breaks = [[[str componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""] componentsSeparatedByString:@","];
        // We can get the expectedPostrolls from the expected pattern if it has postrolls defined
        if (pat && [pat objectForKey:YBOptionKeys.adPositionPost] && [pat objectForKey:YBOptionKeys.adPositionPost][0]) {
            expectedPostrolls = [[pat objectForKey:YBOptionKeys.adPositionPost][0] intValue];
        }
        // If not, while playing postrolls after adbreakstart we can get the givenAds
        else if (breaks) {
            NSString * position = self.requestBuilder.lastSent[YBConstantsRequest.position];
            if (position != nil && [position isEqualToString:@"post"]) {
                expectedPostrolls = [self.requestBuilder.lastSent[YBConstantsRequest.givenAds] intValue];
            }
            // Or before playing postrolls, at least, we can check using breaksTime (from adManifest event) if we expect at least 1 postroll
            if (!expectedPostrolls && breaks) {
                if (breaks.count > 0 && lastMediaDuration) { // If there is no duration probably is a live content, so no postrolls
                    int lastTimePosition = [[breaks lastObject] intValue];
                    if (lastTimePosition + 1 >= lastMediaDuration) {
                        expectedPostrolls = 1;
                    }
                }
                
            }
        }
        // If none of the previous solutions found anything, we assume we have no postrolls
        else {
            return YES;
        }
        // Finally, if the number of played postrolls is the same (or more) than the expected, we can close the view
        if (expectedPostrolls <= self.playedPostrolls) {
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
}

// Ads
- (void) adInitListener:(NSDictionary<NSString *, NSString *> *) params{
    if(self.adsAdapter != nil && self.adsAdapter != nil){
        [self.adapter fireSeekEnd];
        [self.adapter fireBufferEnd];
        
        if(self.adapter.flags.paused){
            [self.adapter.chronos.pause reset];
        }
    }
    [self sendAdInit:params];
}
- (void) adStartListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adapter != nil) {
        [self.adapter fireSeekEnd];
        [self.adapter fireBufferEnd];
        if (self.adapter.flags.paused) {
            [self.adapter.chronos.pause reset];
        }
    }
    
    if (!self.isInitiated && !self.isStarted) {
        if (![[self getAdBreakPosition] isEqualToString:@"post"]) {
            [self fireInit];
        }
    }
    
    if (self.adsAdapter != nil) {
        self.adsAdapter.chronos.adViewedPeriods = [[NSMutableArray alloc] init];
    }
    
    [self.adsAdapter fireAdBreakStart];
    if ([self getAdDuration] != nil && [self getAdTitle] != nil && [self getAdResource] != nil
        && !self.adsAdapter.flags.adInitiated) {
        [self sendAdStart:params];
    } else if (!self.adsAdapter.flags.adInitiated) {
        [self sendAdInit:params];
    }
}

- (void) adJoinListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adsAdapter.flags.adInitiated && !self.isAdStarted) {
        [self sendAdStart:params];
    }
    [self.adsAdapter startChronoView];
    [self sendAdJoin:params];
}


- (void) adPauseListener:(NSDictionary<NSString *, NSString *> *) params {
    [self.adsAdapter stopChronoView];
    [self sendAdPause:params];
}

- (void) adResumeListener:(NSDictionary<NSString *, NSString *> *) params {
    [self.adsAdapter startChronoView];
    [self sendAdResume:params];
}

- (void) adBufferBeginListener:(NSDictionary<NSString *, NSString *> *) params {
    [self.adsAdapter stopChronoView];
    if (self.adsAdapter != nil && self.adsAdapter.flags.paused) {
        [self.adsAdapter.chronos.pause reset];
    }
    [YBLog notice:@"Ad buffer begin"];
}

- (void) adBufferEndListener:(NSDictionary<NSString *, NSString *> *) params {
    [self.adsAdapter startChronoView];
    [self sendAdBufferEnd:params];
}

- (void) adStopListener:(NSDictionary<NSString *, NSString *> *) params {
    [self.adsAdapter stopChronoView];
    
    // Remove time from joinDuration, "delaying" the start time
    if (!(self.adapter != nil && self.adapter.flags.joined) && self.adsAdapter != nil) {
        long long now = [[[YBChrono alloc] init] now];
        //YBChrono* realJoinChrono = self.isInitiated ? self.iinitChrono : self.adapter.chronos.join;
        YBChrono* realJoinChrono = self.iinitChrono;
        
        if(self.adapter != nil && self.adapter.chronos != nil && !self.isInitiated){
            realJoinChrono = self.adapter.chronos.join;
        }
        
        long long startTime = realJoinChrono.startTime;
        if (startTime == 0) {
            startTime = now;
        }
        long long adDeltaTime = self.adsAdapter.chronos.total.getDeltaTime;
        if (adDeltaTime == -1) {
            adDeltaTime = now;
        }
        startTime = MIN(startTime + adDeltaTime, now);
        realJoinChrono.startTime = startTime;
    }
    [self sendAdStop:params];
}

- (void) clickListener:(NSDictionary<NSString *, NSString *> *) params {
    [self.adsAdapter stopChronoView];
    [self sendClick:params];
}

- (void) allAdsCompletedListener:(NSDictionary<NSString *,NSString *>*) params {
    if(self.adapter != nil && self.adapter.flags != nil && !self.adapter.flags.started) [self stopPings];
}

- (void) adErrorListener:(NSDictionary<NSString *,NSString *>*) params {
    if (!self.isInitiated && !self.isStarted) {
        self.adErrorCode = params[@"errorCode"];
        self.adErrorMessage = params[@"errorMsg"];
    } else {
        [self sendAdError:params];
    }
}

- (void) adManifestListener:(NSDictionary<NSString *,NSString *>*) params {
    if (self.isInitiated || self.isStarted) {
        [self sendAdManifest:params];
    }
}

- (void) adBreakStartListener:(NSDictionary<NSString *,NSString *>*) params {
    if (!self.isInitiated && !self.isStarted) {
        if (![[self getAdBreakPosition] isEqualToString:@"post"]) {
            [self fireInit];
        }
    }
    
    [self sendAdBreakStart:params];
}

- (void) adBreakStopListener:(NSDictionary<NSString *,NSString *>*) params {
    [self sendAdBreakStop:params];
}

- (void) adQuartileListener:(NSDictionary<NSString *,NSString *>*) params {
    [self sendAdQuartile:params];
}

// Send methods
- (void) sendInit:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.sInit];
    [self sendWithCallbacks:self.willSendInitListeners service:YBConstantsYouboraService.sInit andParams:mutParams];
    NSString * titleOrResource = mutParams[YBConstantsRequest.title];
    if (titleOrResource == nil) {
        titleOrResource = mutParams[YBConstantsRequest.mediaResource];
    }
    [YBLog notice:@"%@ %@", YBConstantsYouboraService.sInit, titleOrResource];
}

- (void) sendStart:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.start];
    [self sendWithCallbacks:self.willSendStartListeners service:YBConstantsYouboraService.start andParams:mutParams];
    NSString * titleOrResource = mutParams[YBConstantsRequest.title];
    if (titleOrResource == nil) {
        titleOrResource = mutParams[YBConstantsRequest.mediaResource];
    }
    [YBLog notice:@"%@ %@", YBConstantsYouboraService.start, titleOrResource];
    self.isStarted = true;
}

- (void) sendJoin:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.join];
    [self sendWithCallbacks:self.willSendJoinListeners service:YBConstantsYouboraService.join andParams:mutParams];
    [YBLog notice:@"%@ %@ ms", YBConstantsYouboraService.join, mutParams[YBConstantsRequest.joinDuration]];
}

- (void) sendPause:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.pause];
    [self sendWithCallbacks:self.willSendPauseListeners service:YBConstantsYouboraService.pause andParams:mutParams];
    [YBLog notice:@"%@ %@ s", YBConstantsYouboraService.pause, mutParams[YBConstantsRequest.playhead]];
}

- (void) sendResume:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.resume];
    [self sendWithCallbacks:self.willSendResumeListeners service:YBConstantsYouboraService.resume andParams:mutParams];
    [YBLog notice:@"%@ %@ ms", YBConstantsYouboraService.resume, mutParams[YBConstantsRequest.pauseDuration]];
}

- (void) sendSeekEnd:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.seek];
    [self sendWithCallbacks:self.willSendSeekListeners service:YBConstantsYouboraService.seek andParams:mutParams];
    [YBLog notice:@"%@ to %@ in %@ ms", YBConstantsYouboraService.seek, mutParams[YBConstantsRequest.playhead], mutParams[YBConstantsRequest.seekDuration]];
}

- (void) sendBufferEmd:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.buffer];
    [self sendWithCallbacks:self.willSendBufferListeners service:YBConstantsYouboraService.buffer andParams:mutParams];
    [YBLog notice:@"%@ %@ ms", YBConstantsYouboraService.buffer, mutParams[YBConstantsRequest.bufferDuration]];
}

- (void) sendError:(NSDictionary<NSString *, NSString *> *) params {
    if(!self.isInitiated && (self.adapter == nil || (self.adapter != nil && !self.adapter.flags.started))){
        [self.viewTransform nextView];
    }
    if(self.comm == nil){
        [self initComm];
    }
    [self startResourceParsing];
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.error];
    [self sendWithCallbacks:self.willSendErrorListeners service:YBConstantsYouboraService.error andParams:mutParams];
    [YBLog notice:@"%@ %@", YBConstantsYouboraService.error, mutParams[@"errorCode"]];
}

- (void) sendVideoEvent:(NSDictionary<NSString *, NSString*> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraInfinity.videoEvent];
    [self sendWithCallbacks:self.willSendVideoEventListeners service:YBConstantsYouboraInfinity.videoEvent andParams:mutParams];
    [YBLog notice:@"%@", YBConstantsYouboraInfinity.videoEvent];
}

- (void) sendStop:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService: YBConstantsYouboraService.stop];
    [self sendWithCallbacks:self.willSendStopListeners service:YBConstantsYouboraService.stop andParams:mutParams];
    [YBLog notice:@"%@ at %@", YBConstantsYouboraService.stop, mutParams[YBConstantsRequest.playhead]];
}

- (void) sendAdInit:(NSDictionary<NSString *, NSString *> *) params {
    NSString* realNumber = [self.requestBuilder getNewAdNumber];
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adInit];
    mutParams[YBConstantsRequest.adNumber] = realNumber;
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    //Required params
    mutParams[YBConstantsRequest.adDuration] = @"0";
    mutParams[YBConstantsRequest.adPlayhead] = @"0";
    if (self.adsAdapter != nil) {
        self.adsAdapter.flags.adInitiated = true;
    }
    [self sendWithCallbacks:self.willSendAdInitListeners service:YBConstantsYouboraService.adInit andParams:mutParams];
    [YBLog notice:@"%@ %@%@ at %@s", YBConstantsYouboraService.adInit, mutParams[@"adPosition"], mutParams[YBConstantsRequest.adNumber], mutParams[YBConstantsRequest.playhead]];
}

- (void) sendAdStart:(NSDictionary<NSString *, NSString *> *) params {
    [self startPings];
    NSString* realNumber = self.adsAdapter.flags.adInitiated ? self.requestBuilder.lastSent[YBConstantsRequest.adNumber] : [self.requestBuilder getNewAdNumber];
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adStart];
    //mutParams[YBConstantsRequest.adNumber] = self.adsAdapter.flags.adInitiated ? self.requestBuilder.lastSent[YBConstantsRequest.adNumber] : [self.requestBuilder getNewAdNumber]; //[self.requestBuilder getNewAdNumber];
    mutParams[YBConstantsRequest.adNumber] = realNumber;
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdStartListeners service:YBConstantsYouboraService.adStart andParams:mutParams];
    [YBLog notice:@"%@ %@%@ at %@s", YBConstantsYouboraService.adStart, mutParams[@"adPosition"], mutParams[YBConstantsRequest.adNumber], mutParams[YBConstantsRequest.playhead]];
    self.isAdStarted = true;
}

- (void) sendAdJoin:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adJoin];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdJoinListeners service:YBConstantsYouboraService.adJoin andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YBConstantsYouboraService.adJoin, mutParams[YBConstantsRequest.adJoinDuration]];
}

- (void) sendAdPause:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adPause];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdPauseListeners service:YBConstantsYouboraService.adPause andParams:mutParams];
    [YBLog notice:@"%@ at %@s", YBConstantsYouboraService.adPause, mutParams[YBConstantsRequest.adPlayhead]];
}

- (void) sendAdResume:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adResume];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdResumeListeners service:YBConstantsYouboraService.adResume andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YBConstantsYouboraService.adResume, mutParams[YBConstantsRequest.adPauseDuration]];
}

- (void) sendAdBufferEnd:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adBuffer];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdBufferListeners service:YBConstantsYouboraService.adBuffer andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YBConstantsYouboraService.adBuffer, mutParams[YBConstantsRequest.adBufferDuration]];
}

- (void) sendAdStop:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adStop];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdStopListeners service:YBConstantsYouboraService.adStop andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YBConstantsYouboraService.adStop, mutParams[YBConstantsRequest.adTotalDuration]];
    self.isAdStarted = false;
}

- (void) sendClick:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.click];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendClickListeners service:YBConstantsYouboraService.click andParams:mutParams];
    [YBLog notice:@"%@ %@ s", YBConstantsYouboraService.click, mutParams[YBConstantsRequest.playhead]];
}

- (void) sendAdError:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adError];
    NSString* realNumber = self.adsAdapter.flags.adInitiated || self.adsAdapter.flags.started ? self.requestBuilder.lastSent[YBConstantsRequest.adNumber] : [self.requestBuilder getNewAdNumber];
    mutParams[YBConstantsRequest.adNumber] = realNumber;
    [self sendWithCallbacks:self.willSendAdErrorListeners service:YBConstantsYouboraService.adError andParams:mutParams];
    [YBLog notice:@"%@ %@ s", YBConstantsYouboraService.adError, mutParams[@"errorCode"]];
    
}

- (void) sendAdManifest:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adapter != nil && !self.adapter.flags.started && !self.isInitiated) {
        self.adManifestParams = params;
        return;
    }
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adManifest];
    [self sendWithCallbacks:self.willSendAdManifestListeners service:YBConstantsYouboraService.adManifest andParams:mutParams];
    [YBLog notice:YBConstantsYouboraService.adManifest];
}

- (void) sendAdBreakStart:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraService.adBreakStart];
    mutParams[YBConstantsRequest.breakNumber] = [self.requestBuilder getNewAdBreakNumber];
    [self sendWithCallbacks:self.willSendAdBreakStartListeners service:YBConstantsYouboraService.adBreakStart andParams:mutParams];
    [YBLog notice:YBConstantsYouboraService.adBreakStart];
}

- (void) sendAdBreakStop:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService: YBConstantsYouboraService.adBreakStop];
    [self sendWithCallbacks:self.willSendAdBreakStopListeners service:YBConstantsYouboraService.adBreakStop andParams:mutParams];
    [YBLog notice:YBConstantsYouboraService.adBreakStop];
}

- (void) sendAdQuartile:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService: YBConstantsYouboraService.adQuartile];
    mutParams[YBConstantsRequest.adNumber] = self.requestBuilder.lastSent[YBConstantsRequest.adNumber];
    mutParams[YBConstantsRequest.breakNumber] = self.requestBuilder.lastSent[YBConstantsRequest.breakNumber];
    [self sendWithCallbacks:self.willSendAdQuartileListeners service: YBConstantsYouboraService.adQuartile andParams:mutParams];
    [YBLog notice: YBConstantsYouboraService.adQuartile];
}

- (void) sendSessionStart:(NSDictionary<NSString *, NSString *> *) params{
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraInfinity.sessionStart];
    [self initComm];
    [self sendWithCallbacks:self.willSendSessionStartListeners service:YBConstantsYouboraInfinity.sessionStart andParams:mutParams];
    [self startBeats];
    [YBLog notice:YBConstantsYouboraInfinity.sessionStart];
}

- (void) sendSessionStop:(NSDictionary<NSString *, NSString *> *) params{
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService: YBConstantsYouboraInfinity.sessionStop];
    [self sendWithCallbacks:self.willSendSessionStopListeners service:YBConstantsYouboraInfinity.sessionStop andParams:mutParams];
    [self stopBeats];
    [YBLog notice:YBConstantsYouboraInfinity.sessionStop];
    [self initViewTransform: nil];
}

- (void) sendSessionNav:(NSDictionary<NSString *, NSString *> *) params{
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YBConstantsYouboraInfinity.sessionNav];
    [self sendWithCallbacks:self.willSendSessionNavListeners service: YBConstantsYouboraInfinity.sessionNav andParams:mutParams];
    if (self.beatTimer != nil) {
        long long now = [[[YBChrono alloc] init] now];
        long long time = now - self.beatTimer.chrono.startTime;
        [self sendBeat:time];
        [self.beatTimer.chrono setStartTime:now];
    }
    [YBLog notice: YBConstantsYouboraInfinity.sessionNav];
}

- (void) sendSessionEvent:(NSDictionary<NSString *, NSString *> *) params{
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService: YBConstantsYouboraInfinity.sessionEvent ];
    [self sendWithCallbacks:self.willSendSessionEventListeners service:YBConstantsYouboraInfinity.sessionEvent andParams:mutParams];
    [YBLog notice:YBConstantsYouboraInfinity.sessionEvent];
}

- (bool) isLiveOrNotNullDuration {
    return [[self getIsLive] isEqualToValue:@YES]
    || ([[self getIsLive] isEqualToValue:@NO] && ![[self getDuration] isEqualToNumber:@(0)]);
}

// ----------------------------------------- BEATS ---------------------------------------------
- (void) startBeats {
    if (!self.beatTimer.isRunning) {
        [self.beatTimer start];
    }
}

- (void) stopBeats {
    [self.beatTimer stop];
}

- (void) sendBeat:(double) diffTime {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"diffTime"] = @(diffTime).stringValue;
    NSMutableArray<NSString *> * paramList = [NSMutableArray array];
    [paramList addObject:YBConstantsRequest.sessions];
    params = [self.requestBuilder fetchParams:params paramList:paramList onlyDifferent:false];
    
    [self sendWithCallbacks:self.willSendSessionBeatListeners service:YBConstantsYouboraInfinity.sessionBeat andParams:params];
    [YBLog debug: @"%@ params: %@", YBConstantsYouboraInfinity.sessionBeat, params.description];
}

// ------ PINGS ------
- (void) startPings {
    if (!self.pingTimer.isRunning) {
        [self.pingTimer start];
    }
}

- (void) stopPings {
    [self.pingTimer stop];
}

- (void) sendPing:(double) diffTime {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"diffTime"] = @(diffTime).stringValue;
    NSMutableDictionary * changedEntities = [self.requestBuilder getChangedEntitites];
    
    if (changedEntities != nil && changedEntities.count > 0) {
        params[@"entities"] = [YBYouboraUtils stringifyDictionary:changedEntities];
    }
    
    NSMutableArray<NSString *> * paramList = [NSMutableArray array];
    
    if (self.adapter != nil) {
        if (self.adapter.flags.paused) {
            [paramList addObject:YBConstantsRequest.pauseDuration];
        } else {
            [paramList addObject:YBConstantsRequest.bitrate];
            [paramList addObject:YBConstantsRequest.throughput];
            [paramList addObject:YBConstantsRequest.fps];
            
            if (self.adsAdapter != nil && self.adsAdapter.flags.started) {
                [paramList addObject:YBConstantsRequest.adBitrate];
            }
        }
        
        if (self.adapter.flags.joined) {
            [paramList addObject:YBConstantsRequest.playhead];
        }
        
        if (self.adapter.flags.buffering) {
            [paramList addObject:YBConstantsRequest.bufferDuration];
        }
        
        if (self.adapter.flags.seeking) {
            [paramList addObject:YBConstantsRequest.seekDuration];
        }
        
        if ([self.adapter getIsP2PEnabled] != nil && [[self.adapter getIsP2PEnabled] isEqualToValue:@YES]) {
            [paramList addObject:YBConstantsRequest.p2pDownloadedTraffic];
            [paramList addObject:YBConstantsRequest.cdnDownloadedTraffic];
            [paramList addObject:YBConstantsRequest.uploadTraffic];
        }
    }
    
    if (self.adsAdapter != nil) {
        if(self.adsAdapter.flags.adInitiated || self.adsAdapter.flags.started){
            [paramList removeObject:YBConstantsRequest.pauseDuration];
        }
        if (self.adsAdapter.flags.started) {
            [paramList addObject:YBConstantsRequest.adPlayhead];
            [paramList addObject:YBConstantsRequest.playhead];
        }
        
        if (self.adsAdapter.flags.buffering) {
            [paramList addObject:YBConstantsRequest.adBufferDuration];
        }
        
        if (self.adsAdapter.flags.paused) {
            [paramList addObject:YBConstantsRequest.adPauseDuration];
        }
        
        [paramList addObject:YBConstantsRequest.playhead];
    }
    
    params = [self.requestBuilder fetchParams:params paramList:paramList onlyDifferent:false];
    
    [self sendWithCallbacks:self.willSendPingListeners service: YBConstantsYouboraService.ping andParams:params];
    [YBLog debug: @"%@ params: %@", YBConstantsYouboraService.ping, params.description];
}

#pragma mark - Notification from transformer protocol

- (void) transformDone:(NSNotification *) notification {
    if (notification.object == self.resourceTransform) {
        [self startCdnSwitch];
    }
    [self.pingTimer setInterval:self.viewTransform.fastDataConfig.pingTime.longValue * 1000];
    [self.beatTimer setInterval:self.viewTransform.fastDataConfig.beatTime.longValue * 1000];
}

#pragma mark - YBPlayerAdapterEventDelegate

- (void) youboraAdapterEventAdInit:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{
    if (adapter == self.adsAdapter) {
        [self adInitListener:params];
    }
}

- (void) youboraAdapterEventStart:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self startListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adStartListener:params];
    }
}

- (void) youboraAdapterEventJoin:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self joinListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adJoinListener:params];
    }
}

- (void) youboraAdapterEventPause:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self pauseListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adPauseListener:params];
    }
}

- (void) youboraAdapterEventResume:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self resumeListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adResumeListener:params];
    }
}

- (void) youboraAdapterEventVideoEvent:(nullable NSDictionary *)params fromAdapter:(YBPlayerAdapter *) adapter {
    [self videoEventListener: params];
}

- (void) youboraAdapterEventStop:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self stopListener:params];
    } else if (adapter == self.adsAdapter) {
        // If its a stop for a postroll we check if we can detect if its the last one to call view stop
        if ([self.requestBuilder.lastSent[YBConstantsRequest.position] isEqualToString:@"post"]) {
            NSDictionary * pat = self.options.adExpectedPattern;
            NSNumber * givenAds = self.requestBuilder.lastSent[YBConstantsRequest.givenAds];
            ++self.playedPostrolls;
            if ((givenAds && [givenAds intValue] <= self.playedPostrolls) // If we know the amount of postrolls and this was the last one
                || (!givenAds && pat && [pat objectForKey:YBOptionKeys.adPositionPost] && [pat objectForKey:YBOptionKeys.adPositionPost][0] && [[pat objectForKey:YBOptionKeys.adPositionPost][0] intValue] <= self.playedPostrolls)) // Or if we have expected (and not given!) and this was the last expected one
            {
                [self adStopListener:params];
                [self fireStop];
            } else {
                [self adStopListener:params];
            }
        } else {
            [self adStopListener:params];
        }
    }
}

- (void) youboraAdapterEventClick:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adsAdapter) {
        [self clickListener:params];
    }
}

- (void) youboraAdapterEventAllAdsCompleted:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adsAdapter) {
        [self allAdsCompletedListener:params];
    }
}

- (void) youboraAdapterEventBufferBegin:(nullable NSDictionary *) params convertFromSeek:(bool) convertFromSeek fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self bufferBeginListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adBufferBeginListener:params];
    }
}

- (void) youboraAdapterEventBufferEnd:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self bufferEndListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adBufferEndListener:params];
    }
}

- (void) youboraAdapterEventSeekBegin:(nullable NSDictionary *) params convertFromBuffer:(bool) convertFromBuffer fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self seekBeginListener:params];
    }
}

- (void) youboraAdapterEventSeekEnd:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self seekEndListener:params];
    }
}

- (void) youboraAdapterEventError:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self errorListener:params];
    } else if(adapter == self.adsAdapter) {
        [self adErrorListener:params];
    }
}

- (void) youboraAdapterEventAdManifest:(NSDictionary *)params fromAdapter:(YBPlayerAdapter *)adapter {
    if (adapter == self.adsAdapter) {
        [self adManifestListener:params];
    }
}

- (void) youboraAdapterEventAdManifestError:(NSDictionary *)params fromAdapter:(YBPlayerAdapter *)adapter {
    if (adapter == self.adsAdapter) {
        [self adManifestListener:params];
    }
}

- (void) youboraAdapterEventAdBreakStart:(NSDictionary *)params fromAdapter:(YBPlayerAdapter *)adapter {
    if (adapter == self.adsAdapter) {
        [self adBreakStartListener:params];
    }
}

- (void) youboraAdapterEventAdBreakStop:(NSDictionary *)params fromAdapter:(YBPlayerAdapter *)adapter {
    if (adapter == self.adsAdapter) {
        [self adBreakStopListener:params];
    }
}

- (void) youboraAdapterEventAdQuartile:(NSDictionary *)params fromAdapter:(YBPlayerAdapter *)adapter {
    if (adapter == self.adsAdapter) {
        [self adQuartileListener:params];
    }
}

- (void) youboraInfinityEventSessionStartWithScreenName: (NSString *) screenName andDimensions:(NSDictionary<NSString *, NSString *> *) dimensions {
    [self.viewTransform nextView];
    
    self.startScreenName = screenName;
    self.startDimensions = dimensions;
    
    NSString *stringyfiedDict = [YBYouboraUtils stringifyDictionary:dimensions];
    
    if (stringyfiedDict == nil)
        stringyfiedDict = @"";
    
    NSDictionary *params = @{
        @"dimensions" : stringyfiedDict,
        @"page" : screenName,
        @"route" : screenName
    };
    
    [self sendSessionStart:params];
}

- (void) youboraInfinityEventSessionStop: (NSDictionary<NSString *, NSString *> *) params {
    [self sendSessionStop:params];
    self.infinity = nil;
}

- (void) youboraInfinityEventNavWithScreenName: (NSString *) screenName {
    
    NSDictionary *params = @{
        @"page" : screenName,
        @"route" : screenName
    };
    [self sendSessionNav:params];
}

- (void)youboraInfinityEventEventWithDimensions:(NSDictionary<NSString *,NSString *> *)dimensions values:(NSDictionary<NSString *,NSNumber *> *)values andEventName:(NSString *)eventName andTopLevelDimensions:(NSDictionary<NSString *,NSString *> *)topLevelDimensions {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params addEntriesFromDictionary:topLevelDimensions];
    params[@"dimensions"] = [YBYouboraUtils stringifyDictionary:dimensions];
    params[@"values"] = [YBYouboraUtils stringifyDictionary:values];
    params[@"name"] = eventName;
    
    [self sendSessionEvent:params];
}

- (BOOL) isExtraMetadataReady {
    NSDictionary *dictOpts = [self.options toDictionary];
    
    if (self.options.pendingMetadata != nil && self.options.waitForMetadata) {
        NSMutableArray *pendingMetadataKeys = [[NSMutableArray alloc] initWithArray:self.options.pendingMetadata];
        NSMutableArray *pendingDataToRemove = [[NSMutableArray alloc] init];
        for (NSString * pendingKey in pendingMetadataKeys) {
            if (dictOpts[pendingKey] == nil) {
                [self removeNotPendingOptions:pendingDataToRemove];
                return false;
            } else {
                [pendingDataToRemove addObject:pendingKey];
            }
        }
        [self removeNotPendingOptions:pendingDataToRemove];
    }
    return true;
}

- (void) removeNotPendingOptions: (NSArray *) readykeys {
    NSMutableArray *pendingMetadataKeys = [[NSMutableArray alloc] initWithArray:self.options.pendingMetadata];
    [pendingMetadataKeys removeObjectsInArray:readykeys];
}

- (void) startMetadataTimer {
    if (self.options.pendingMetadata != nil && self.options.waitForMetadata) {
        [self.metadataTimer start];
    }
}

@end
