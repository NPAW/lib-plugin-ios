//
//  YBPlugin.m
//  YouboraLib
//
//  Created by Joan on 22/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBPlugin.h"

#import "YBRequestBuilder.h"
#import "YBChrono.h"
#import "YBOptions.h"
#import "YBLog.h"
#import "YBViewTransform.h"
#import "YBResourceTransform.h"
#import "YBPlayerAdapter.h"
#import "YBRequest.h"
#import "YBCommunication.h"
#import "YBConstants.h"
#import "YBTimer.h"
#import "YBYouboraUtils.h"
#import "YBPlaybackFlags.h"
#import "YBPlaybackChronos.h"
#import "YBFastDataConfig.h"
#import "YBFlowTransform.h"
#import "YBNqs6Transform.h"
#import "YBPlayheadMonitor.h"
#import "YBOfflineTransform.h"
#import "YBEventDataSource.h"
#import "YBEvent.h"

@interface YBPlugin()

// Redefinition with readwrite access
@property(nonatomic, strong, readwrite) YBResourceTransform * resourceTransform;
@property(nonatomic, strong, readwrite) YBViewTransform * viewTransform;
@property(nonatomic, strong, readwrite) YBRequestBuilder * requestBuilder;
@property(nonatomic, strong, readwrite) YBTimer * pingTimer;
@property(nonatomic, strong, readwrite) YBCommunication * comm;

// Private properties
@property(nonatomic, assign) bool isInitiated;
@property(nonatomic, assign) bool isPreloading;
@property(nonatomic, strong) YBChrono * preloadChrono;
@property(nonatomic, strong) YBChrono * iinitChrono;

@property(nonatomic, strong) NSString * lastServiceSent;

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

@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdInitListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdStartListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdJoinListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdPauseListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdResumeListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdBufferListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdStopListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendClickListeners;
@property(nonatomic, strong) NSMutableArray<YBWillSendRequestBlock> * willSendAdErrorListeners;

@end

@implementation YBPlugin

#pragma mark - Init
- (instancetype) initWithOptions:(YBOptions *) options {
    return [self initWithOptions:options andAdapter:nil];
}

- (instancetype) initWithOptions:(YBOptions *) options andAdapter:(YBPlayerAdapter *) adapter {
    self = [super init];
    if (self) {
        if (options == nil) {
            [YBLog warn:@"Options is nil"];
            options = [YBOptions new];
        };
        
        self.isInitiated = false;
        self.isPreloading = false;
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
        self.requestBuilder = [self createRequestBuilder];
        self.resourceTransform = [self createResourceTransform];
        self.viewTransform = [self createViewTransform];
        [self.viewTransform addTransformDoneListener:self];
        
        [self.viewTransform begin];
        
        self.lastServiceSent = nil;
    }
    return self;
}

#pragma mark - Public methods
- (void)setAdapter:(YBPlayerAdapter *)adapter {
    [self removeAdapter: false];
    
    if (adapter != nil) {
        _adapter = adapter;
        adapter.plugin = self;
        [adapter addYouboraAdapterDelegate:self];
        
        if(self.options.autoDetectBackground){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(eventListenerDidReceivetoBack:)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
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
        
        if(self.options.autoDetectBackground){
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        }
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
    if (!self.isInitiated) {
        [self.viewTransform nextView];
        [self initComm];
        [self startPings];
        
        self.isInitiated = true;
        [self.iinitChrono start];
        
        [self sendInit:params];
    }
    //TODO: check why this no added
    //[self startResourceParsing];
}

- (void) fireErrorWithParams:(NSDictionary<NSString *, NSString *> *) params {
    [self sendError:[YBYouboraUtils buildErrorParams:params]];
}

- (void) fireErrorWithMessage:(NSString *) msg code:(NSString *) code andErrorMetadata:(NSString *) errorMetadata {
    [self sendError:[YBYouboraUtils buildErrorParamsWithMessage:msg code:code metadata:errorMetadata andLevel:@"error"]];
}
- (void) fireFatalErrorWithMessage:(NSString *) msg code:(NSString *) code andErrorMetadata:(NSString *) errorMetadata andException:(nullable NSException*) exception{
    if(self.adapter != nil){
        if(exception != nil){
            [self.adapter fireErrorWithMessage:msg code:code andMetadata:errorMetadata andException:exception];
        }else{
            [self.adapter fireErrorWithMessage:msg code:code andMetadata:errorMetadata];
        }
    }else{
        [self fireErrorWithParams:[YBYouboraUtils buildErrorParamsWithMessage:msg code:code metadata:errorMetadata andLevel:@""]];
    }
    [self fireStop];
}

- (void) fireStop{
    [self fireStop:nil];
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
    
    self.comm = [self createCommunication];
    [self.comm addTransform:self.viewTransform];
    
    YBEventDataSource *dataSource = [[YBEventDataSource alloc] init];
    [dataSource allEventsWithCompletion:^(NSArray* events){
        if(events != nil && events.count == 0){
            [YBLog debug:@"No offline events, skipping..."];
            return;
        }
        [dataSource lastIdWithCompletion:^(NSNumber * offlineId){
            int lastId = [offlineId intValue];
            for(int k = lastId ; k >= 0  ; k--){
                [dataSource eventsWithOfflineId:[NSNumber numberWithInt:k] completion:^(NSArray * events){
                    if(events == nil){
                        return;
                    }
                    if(events.count == 0){
                        return;
                    }
                    //YBEvent *event = events[0];
                    [self sendOfflineEventsWithEventsString:[self generateOfflineJsonStringWithEvents:events] andOfflineId:((YBEvent *)events[0]).offlineId];
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
    [listenerParams setValue:offlineId forKey:YouboraSuccsessListenerOfflineId];
    YBRequestSuccessBlock successListener = ^(NSData * data, NSURLResponse * response,  NSDictionary<NSString *, id>* listenerParams) {
        __block YBEventDataSource* dataSource = [[YBEventDataSource alloc] init];
        [dataSource deleteEventsWithOfflineId:offlineId completion:^{
            [YBLog debug:@"Offline events deleted"];
        }];
    };
    [self sendWithCallbacks:nil service:YouboraServiceOffline andParams:nil andMethod:YouboraHTTPMethodPost andBody:events withSuccessListener:successListener andSuccessListenerParams:listenerParams];
    /*NSMutableDictionary<NSString*, NSString*> *params = [[NSMutableDictionary alloc] init];
    params[@"events"] = events;
    params[@"offlineId"] = [offlineId stringValue];
    [self sendWithCallbacks:nil service:YouboraServiceOffline andParams:params];*/
}

// ------ INFO GETTERS ------
- (NSString *) getHost {
    return [YBYouboraUtils addProtocol:[YBYouboraUtils stripProtocol:self.options.host] https:self.options.httpSecure];
}

- (bool) isParseHls {
    return self.options.parseHls;
}

- (bool) isParseCdnNode {
    return self.options.parseCdnNode;
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
    NSString * val = self.options.contentTitle2;
    if ((val == nil || val.length == 0) && self.adapter != nil) {
        @try {
            val = [self.adapter getTitle2];
        } @catch (NSException *exception) {
            [YBLog warn:@"An error occurred while calling getTitle2"];
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
    NSString * val = nil;
    if (![self.resourceTransform isBlocking:nil]) {
        val = [self.resourceTransform getResource];
    }
    
    if (val == nil) {
        val = [self getOriginalResource];
    }
    
    return val;
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
    return self.options.contentStreamingProtocol;
}


- (NSString *)getTransactionCode {
    return self.options.contentTransactionCode;
}

- (NSString *) getContentMetadata {
    return [YBYouboraUtils stringifyDictionary:self.options.contentMetadata];
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
    NSString * cdn = nil;
    if (![self.resourceTransform isBlocking:nil]) {
        cdn = [self.resourceTransform getCdnName];
    }
    
    if (cdn == nil) {
        cdn = self.options.contentCdn;
    }
    return cdn;
}

- (NSNumber *)getLatency{
    NSNumber * val = nil;
    if (self.adapter != nil) {
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
        ver = [YouboraLibVersion stringByAppendingString:@"-adapterless"];
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
            [YBLog warn:@"An error occurred while calling ad getVersion"];
            [YBLog logException:exception];
        }
    }
    
    return val;
}

- (NSString *) getAdMetadata {
    return [YBYouboraUtils stringifyDictionary:self.options.adMetadata];
}

- (NSString *) getPluginInfo {

    NSMutableDictionary * info = [NSMutableDictionary dictionaryWithObject:YouboraLibVersion forKey:@"lib"];
    
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
    return self.options.networkObfuscateIp;
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

- (NSString *) getNodeHost {
    return [self.resourceTransform getNodeHost];
}

- (NSString *) getNodeType {
    return [self.resourceTransform getNodeType];
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

/**
 * Adds a ad error listener
 * @param listener to add
 */
-(void) addWillSendAdErrorListener:(YBWillSendRequestBlock) listener{
    if(self.willSendAdErrorListeners == nil)
        self.willSendAdErrorListeners = [NSMutableArray arrayWithCapacity:1];
    [self.willSendAdErrorListeners addObject:listener];
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

#pragma mark - Private methods
- (YBChrono *) createChrono {
    return [YBChrono new];
}

- (YBTimer *) createTimerWithCallback:(TimerCallback)callback andInterval:(long) interval {
    return [[YBTimer alloc] initWithCallback:callback andInterval:interval];
}

- (YBRequestBuilder *) createRequestBuilder {
    return [[YBRequestBuilder alloc] initWithPlugin:self];
}

- (YBResourceTransform *) createResourceTransform {
    return [[YBResourceTransform alloc] initWithPlugin:self];
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

- (YBCommunication *) createCommunication {
    return [YBCommunication new];
}

- (YBFlowTransform *) createFlowTransform {
    return [YBFlowTransform new];
}

- (YBNqs6Transform *) createNqs6Transform {
    return [YBNqs6Transform new];
}

- (void) reset {
    [self stopPings];
    
    self.resourceTransform = [self createResourceTransform];
    self.isInitiated = false;
    self.isPreloading = false;
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
    
    if (self.comm != nil && params != nil && self.options.enabled) {
        YBRequest * r = [self createRequestWithHost:nil andService:service];
        r.params = params;
        r.method = method;
        r.body = body;
        
        self.lastServiceSent = r.service;
        
        [self.comm sendRequest:r withCallback:successListener andListenerParams:successListenerParams];
        
        /*if([service isEqualToString:YouboraServiceOffline]){
            __block YBEventDataSource* dataSource = [[YBEventDataSource alloc] init];
            r.method = YouboraHTTPMethodPost;
            
            YBRequestSuccessBlock successListener = ^(NSData * data, NSURLResponse * response,  NSDictionary<NSString *, id>* listenerParams) {
                [dataSource deleteEventsWithOfflineId:offlineId completion:^{
                    [YBLog debug:@"Offline events deleted"];
                }];
            };
            NSNumber* blockOfflineId = params[@"offlineId"] == nil ? @-1 : @([params[@"offlineId"] intValue]);
            [r.params removeObjectForKey:@"offlineId"];
            [self.comm sendRequest:r withCallback:successListener];
        }else{
            [self.comm sendRequest:r withCallback:nil];
        }*/
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
    self.comm = [self createCommunication];
    [self.comm addTransform:[self createFlowTransform]];
    
    [self.comm addTransform:self.resourceTransform];
    [self.comm addTransform:[self createNqs6Transform]];
    
    if(self.options.offline){
        [self.comm addTransform:[self createOfflineTransform]];
    }else{
        [self.comm addTransform:self.viewTransform];
    }
}

- (void) startResourceParsing {
    if (!self.resourceTransform.isBusy && !self.resourceTransform.isFinished) {
        NSString * res = [self getResource];
        
        if (res) {
            [self.resourceTransform begin:res];
        }
    }
}

- (void) eventListenerDidReceivetoBack:(NSNotification*)uselessNotification {
    if(self.adapter != nil){
        [self.adapter fireStop];
    }
}

// Listener methods
- (void) startListener:(NSDictionary<NSString *, NSString *> *) params {
    if (!self.isInitiated || [YouboraServiceError isEqualToString:self.lastServiceSent]) {
        [self.viewTransform nextView];
        [self initComm];
        [self startPings];
    }
    
    [self startResourceParsing];
    
    [self sendStart:params];
}

- (void) joinListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adsAdapter == nil || !self.adsAdapter.flags.started) {
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

- (void) stopListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendStop:params];
    [self reset];
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
    
    [self sendAdStart:params];
}

- (void) adJoinListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendAdJoin:params];
}


- (void) adPauseListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendAdPause:params];
}

- (void) adResumeListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendAdResume:params];
}

- (void) adBufferBeginListener:(NSDictionary<NSString *, NSString *> *) params {
    if (self.adsAdapter != nil && self.adsAdapter.flags.paused) {
        [self.adsAdapter.chronos.pause reset];
    }
    [YBLog notice:@"Ad buffer begin"];
}

- (void) adBufferEndListener:(NSDictionary<NSString *, NSString *> *) params {
    [self sendAdBufferEnd:params];
}

- (void) adStopListener:(NSDictionary<NSString *, NSString *> *) params {
    // Remove time from joinDuration, "delaying" the start time
    
    if (!(self.adapter != nil && self.adapter.flags.joined) && self.adsAdapter != nil) {
        long long now = [YBChrono getNow];
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
    [self sendClick:params];
}

- (void) allAdsCompletedListener:(NSDictionary<NSString *,NSString *>*) params{
    if(self.adapter != nil && self.adapter.flags != nil && !self.adapter.flags.started) [self stopPings];
}

- (void) adErrorListener:(NSDictionary<NSString *,NSString *>*) params{
    [self sendAdError:params];
}

// Send methods
- (void) sendInit:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceInit];
    [self sendWithCallbacks:self.willSendInitListeners service:YouboraServiceInit andParams:mutParams];
    NSString * titleOrResource = mutParams[@"title"];
    if (titleOrResource == nil) {
        titleOrResource = mutParams[@"mediaResource"];
    }
    [YBLog notice:@"%@ %@", YouboraServiceInit, titleOrResource];
}

- (void) sendStart:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceStart];
    [self sendWithCallbacks:self.willSendStartListeners service:YouboraServiceStart andParams:mutParams];
    NSString * titleOrResource = mutParams[@"title"];
    if (titleOrResource == nil) {
        titleOrResource = mutParams[@"mediaResource"];
    }
    [YBLog notice:@"%@ %@", YouboraServiceStart, titleOrResource];
}

- (void) sendJoin:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceJoin];
    [self sendWithCallbacks:self.willSendJoinListeners service:YouboraServiceJoin andParams:mutParams];
    [YBLog notice:@"%@ %@ ms", YouboraServiceJoin, mutParams[@"joinDuration"]];
}

- (void) sendPause:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServicePause];
    [self sendWithCallbacks:self.willSendPauseListeners service:YouboraServicePause andParams:mutParams];
    [YBLog notice:@"%@ %@ s", YouboraServicePause, mutParams[@"playhead"]];
}

- (void) sendResume:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceResume];
    [self sendWithCallbacks:self.willSendResumeListeners service:YouboraServiceResume andParams:mutParams];
    [YBLog notice:@"%@ %@ ms", YouboraServiceResume, mutParams[@"pauseDuration"]];
}

- (void) sendSeekEnd:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceSeek];
    [self sendWithCallbacks:self.willSendSeekListeners service:YouboraServiceSeek andParams:mutParams];
    [YBLog notice:@"%@ to %@ in %@ ms", YouboraServiceSeek, mutParams[@"playhead"], mutParams[@"seekDuration"]];
}

- (void) sendBufferEmd:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceBuffer];
    [self sendWithCallbacks:self.willSendBufferListeners service:YouboraServiceBuffer andParams:mutParams];
    [YBLog notice:@"%@ %@ ms", YouboraServiceBuffer, mutParams[@"bufferDuration"]];
}

- (void) sendError:(NSDictionary<NSString *, NSString *> *) params {
    if(!self.isInitiated && (self.adapter == nil || (self.adapter != nil && !self.adapter.flags.started))){
        [self.viewTransform nextView];
    }
    if(self.comm == nil){
        [self initComm];
    }
    [self startResourceParsing];
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceError];
    [self sendWithCallbacks:self.willSendErrorListeners service:YouboraServiceError andParams:mutParams];
    [YBLog notice:@"%@ %@", YouboraServiceError, mutParams[@"errorCode"]];
}

- (void) sendStop:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceStop];
    [self sendWithCallbacks:self.willSendStopListeners service:YouboraServiceStop andParams:mutParams];
    [YBLog notice:@"%@ at %@", YouboraServiceStop, mutParams[@"playhead"]];
}
    
- (void) sendAdInit:(NSDictionary<NSString *, NSString *> *) params {
    NSString* realNumber = [self.requestBuilder getNewAdNumber];
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdInit];
    mutParams[@"adNumber"] = realNumber;
    //Required params
    mutParams[@"adDuration"] = @"0";
    mutParams[@"adPlayhead"] = @"0";
    [self sendWithCallbacks:self.willSendAdInitListeners service:YouboraServiceAdInit andParams:mutParams];
    [YBLog notice:@"%@ %@%@ at %@s", YouboraServiceAdInit, mutParams[@"adPosition"], mutParams[@"adNumber"], mutParams[@"playhead"]];
}

- (void) sendAdStart:(NSDictionary<NSString *, NSString *> *) params {
    [self startPings];
    NSString* realNumber = self.adsAdapter.flags.adInitiated ? self.requestBuilder.lastSent[@"adNumber"] : [self.requestBuilder getNewAdNumber];
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdStart];
    //mutParams[@"adNumber"] = self.adsAdapter.flags.adInitiated ? self.requestBuilder.lastSent[@"adNumber"] : [self.requestBuilder getNewAdNumber]; //[self.requestBuilder getNewAdNumber];
    mutParams[@"adNumber"] = realNumber;
    [self sendWithCallbacks:self.willSendAdStartListeners service:YouboraServiceAdStart andParams:mutParams];
    [YBLog notice:@"%@ %@%@ at %@s", YouboraServiceAdStart, mutParams[@"adPosition"], mutParams[@"adNumber"], mutParams[@"playhead"]];
}

- (void) sendAdJoin:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdJoin];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendAdJoinListeners service:YouboraServiceAdJoin andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YouboraServiceAdJoin, mutParams[@"adJoinDuration"]];
}

- (void) sendAdPause:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdPause];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendAdPauseListeners service:YouboraServiceAdPause andParams:mutParams];
    [YBLog notice:@"%@ at %@s", YouboraServiceAdPause, mutParams[@"adPlayhead"]];
}

- (void) sendAdResume:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdResume];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendAdResumeListeners service:YouboraServiceAdResume andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YouboraServiceAdResume, mutParams[@"adPauseDuration"]];
}

- (void) sendAdBufferEnd:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdBuffer];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendAdBufferListeners service:YouboraServiceAdBuffer andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YouboraServiceAdBuffer, mutParams[@"adBufferDuration"]];
}

- (void) sendAdStop:(NSDictionary<NSString *, NSString *> *) params {
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdStop];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendAdStopListeners service:YouboraServiceAdStop andParams:mutParams];
    [YBLog notice:@"%@ %@ms", YouboraServiceAdStop, mutParams[@"adTotalDuration"]];
}

- (void) sendClick:(NSDictionary<NSString *, NSString *> *) params{
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceClick];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendClickListeners service:YouboraServiceClick andParams:mutParams];
    [YBLog notice:@"%@ %@ s", YouboraServiceClick, mutParams[@"playhead"]];
}

- (void) sendAdError:(NSDictionary<NSString *, NSString *> *) params{
    NSMutableDictionary * mutParams = [self.requestBuilder buildParams:params forService:YouboraServiceAdError];
    mutParams[@"adNumber"] = self.requestBuilder.lastSent[@"adNumber"];
    [self sendWithCallbacks:self.willSendAdErrorListeners service:YouboraServiceAdError andParams:mutParams];
    [YBLog notice:@"%@ %@ s", YouboraServiceClick, mutParams[@"playhead"]];

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
            [paramList addObject:@"pauseDuration"];
        } else {
            [paramList addObject:@"bitrate"];
            [paramList addObject:@"throughput"];
            [paramList addObject:@"fps"];
            
            if (self.adsAdapter != nil && self.adsAdapter.flags.started) {
                [paramList addObject:@"adBitrate"];
            }
        }
        
        if (self.adapter.flags.joined) {
            [paramList addObject:@"playhead"];
        }
        
        if (self.adapter.flags.buffering) {
            [paramList addObject:@"bufferDuration"];
        }
        
        if (self.adapter.flags.seeking) {
            [paramList addObject:@"seekDuration"];
        }
        
    }
    
    if (self.adsAdapter != nil) {
        if(self.adsAdapter.flags.adInitiated || self.adsAdapter.flags.started){
            [paramList removeObject:@"pauseDuration"];
        }
        if (self.adsAdapter.flags.started) {
            [paramList addObject:@"adPlayhead"];
            [paramList addObject:@"playhead"];
        }
        
        if (self.adsAdapter.flags.buffering) {
            [paramList addObject:@"adBufferDuration"];
        }
        [paramList addObject:@"playhead"];
    }
    
    params = [self.requestBuilder fetchParams:params paramList:paramList onlyDifferent:false];
    
    [self sendWithCallbacks:self.willSendPingListeners service:YouboraServicePing andParams:params];
    [YBLog debug:YouboraServicePing];
}

#pragma mark - YBTransformDoneListener protocol
- (void) transformDone:(YBTransform *) transform {
    [self.pingTimer setInterval:self.viewTransform.fastDataConfig.pingTime.longValue * 1000];
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

- (void) youboraAdapterEventStop:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter {
    if (adapter == self.adapter) {
        [self stopListener:params];
    } else if (adapter == self.adsAdapter) {
        [self adStopListener:params];
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
        [self adBufferEndListener:params];
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


@end
