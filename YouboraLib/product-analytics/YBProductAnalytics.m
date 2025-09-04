//
//  YBProductAnalytics.m
//  YouboraLib
//
//  Created by Francisco Expósito on 06-02-2024.
//  Copyright © 2024 NPAW. All rights reserved.
//

#import "YBProductAnalytics.h"
#import "YBLog.h"
#import "YBInfinityFlags.h"
#import "YouboraLib/YouboraLib-Swift.h"

// ---------------------------------------------------------------------------------------------
// YBProductAnalyticsPlayerAdapterEventDelegate
// ---------------------------------------------------------------------------------------------

/**
 * Here we are defining a (private) custom YBPlayerAdapterEventDelegate so we can receive a youboraAdapterEventStart notification.
 * It receives the callback function as a constructor argument. This callback function will be called upon start event.
 */

@interface YBProductAnalyticsPlayerAdapterEventDelegate : NSObject <YBPlayerAdapterEventDelegate>
    @property(nonatomic, copy) void (^adapterStartCallback)(void);
@end

@implementation YBProductAnalyticsPlayerAdapterEventDelegate

- (instancetype)init {
    return [self initWithAdapterStartCallback:nil];
}

- (instancetype)initWithAdapterStartCallback:(void (^)(void))adapterStartCallback {
    self = [super init];
    if (self) {
        self.adapterStartCallback = [adapterStartCallback copy];
    }
    return self;
}

/**
 * Adapter detected an adInit event
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAdInit:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}


- (void)youboraAdapterEventStart:(nullable NSDictionary *)params fromAdapter:(YBPlayerAdapter *)adapter {
    if ( self.adapterStartCallback ){
        self.adapterStartCallback();
    }
}

/**
 * Adapter detected a join event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventJoin:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a pause event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventPause:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a resume event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventResume:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a stop event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventStop:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a buffer begin event.
 * @param params params to add to the request
 * @param convertFromSeek whether the buffer has been converted from a seek or not
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventBufferBegin:(nullable NSDictionary *) params convertFromSeek:(bool) convertFromSeek fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a buffer end event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventBufferEnd:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a seek begin event.
 * @param params params to add to the request
 * @param convertFromBuffer whether the seek has been converted from a buffer or not
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventSeekBegin:(nullable NSDictionary *) params convertFromBuffer:(bool) convertFromBuffer fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected a seek end event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventSeekEnd:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected an error event.
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventError:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected video event
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventVideoEvent:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected ad click
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventClick:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/**
 * Adapter detected when all ads finished playing
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAllAdsCompleted:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/** Adapter detected a quartitle has been reached
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAdQuartile:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/** Adapter detected a successful ad manifest request
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAdManifest:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/** Adapter detected a unsuccessful ad manifest request
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAdManifestError:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/** Adapter detected a ad break start
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAdBreakStart:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}

/** Adapter detected a ad break finished
 * @param params params to add to the request
 * @param adapter the adapter that is firing the event
 */
- (void) youboraAdapterEventAdBreakStop:(nullable NSDictionary *) params fromAdapter:(YBPlayerAdapter *) adapter{}


@end

// ---------------------------------------------------------------------------------------------
// YBPendingVideoEvent
// ---------------------------------------------------------------------------------------------


@interface YBPendingVideoEvent : NSObject<NSCopying>

@property (nonatomic, copy) NSString * eventName;
@property (nonatomic, copy) NSString * contentId;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * dimensions;
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> * metrics;
@property (nonatomic, assign) BOOL startEvent;

@end

@implementation YBPendingVideoEvent

- (instancetype)initWithEventName: (NSString *)eventName
                        contentId: (NSString *)contentId
                       dimensions: (NSDictionary<NSString *, NSString *> *)dimensions
                          metrics: (NSDictionary<NSString *, NSNumber *> *)metrics
                       startEvent: (BOOL)startEvent{
    self = [super init];
    if (self) {
        _eventName  = [eventName copy];
        _contentId  = [contentId copy];
        _dimensions = [dimensions copy];
        _metrics    = [metrics copy];
        _startEvent = startEvent;
    }
    return self;
}

- (void)destroy {
    _eventName  = nil;
    _contentId  = nil;
    _dimensions = nil;
    _metrics    = nil;
    _startEvent = false;
}

- (id)copyWithZone:(NSZone *)zone {
    YBPendingVideoEvent *copy = [[[self class] allocWithZone:zone] init];

    if (copy) {
        copy.eventName = [self.eventName copy];
        copy.contentId = [self.contentId copy];
        copy.dimensions = [self.dimensions copy];
        copy.metrics = [self.metrics copy];
        copy.startEvent = self.startEvent;
    }
    
    return copy;
}

@end

// ---------------------------------------------------------------------------------------------
// YBProductAnalytics
// ---------------------------------------------------------------------------------------------


// Private attribute and method definition

@interface YBProductAnalytics ()

typedef enum {
  eventTypeUserProfile,
  eventTypeUser,
  eventTypeNavigation,
  eventTypeAttribution,
  eventTypeSection,
  eventTypeContentPlayback,
  eventTypeSearch,
  eventTypeExternalApplication,
  eventTypeEngagement,
  eventTypeCustom
} EventTypes;

@property(nonatomic, strong) YBProductAnalyticsPlayerAdapterEventDelegate * playerAdapterEventDelegate;

@property (nonatomic, strong) NSMutableArray<YBPendingVideoEvent*> * pendingVideoEvents;

- (void) loginSuccessfulEvent: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) userProfileSelectedEvent: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackContentHighlight:(NSTimer *)timer;

- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics startEvent: (Boolean) startEvent;

- (void) trackPlayerEventsPending;

- (void) trackPlayerEvent: (nonnull NSString *) eventName contentId: (nullable NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics startEvent: (Boolean) startEvent;

- (void) addPlayerEventPending: (nonnull NSString *) eventName contentId: (nullable NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics startEvent: (Boolean) startEvent;

- (void) releasePlayerEventsPending;

- (Boolean) fireEvent: (nonnull NSString *) eventName eventType: (EventTypes) eventType dimensionsInternal: (nullable NSDictionary<NSString *, NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *, NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (Boolean)fireAdapterEvent:(nonnull NSString *)eventName dimensionsInternal: (nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *,NSNumber *> *) metrics;

- (NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> * _Nonnull)buildDimensions: (EventTypes) eventType dimensionsInternal: (nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser;

- (void) setUserId: (NSString *) userId;
- (void) setProfileId: (NSString *) profileId;

@end

// Class implementation

@implementation YBProductAnalytics

/**
 * This class is the base of Product Analytics. Every plugin will have an instance.
 * @param options The options instance allowing to set custom content dimensions
 * @param infinity  The infinity instance  that will be used to send events to server
 * @constructs YBProductAnalytics
 */
- (id)init: (YBOptions *) options infinity: (YBInfinity *) infinity{
    if (self = [super init]) {
        self._options = options;
        self._infinity = infinity;
        self._adapter = nil;

        self._productAnalyticsSettings = [YBProductAnalyticsSettings new];

        self._screenName  = @"";
        self._searchQuery = @"";

        self._userState = nil;

        self._contentHighlightTimeout = nil;
        self._initialized = false;

        self.playerAdapterEventDelegate = [[YBProductAnalyticsPlayerAdapterEventDelegate alloc] initWithAdapterStartCallback: ^{
            if (self._initialized){
                [self trackPlayerInteraction: @"start" dimensions: @{} metrics: @{} startEvent: true];
            }
        }];

        self.pendingVideoEvents = [[NSMutableArray alloc] init];

        if ( self._options == nil ){
            [YBLog warn: @"Options reference unset"];
        }

        if ( self._infinity == nil ){
            [YBLog warn: @"Infinity reference unset"];
        }
    }
    return self;
}

// ------------------------------------------------------------------------------------------------------
// INITIALIZE / DESTROY
// ------------------------------------------------------------------------------------------------------

/**
  * Initializes product analytics
  * @param screenName Name of the current screen
  * @param productAnalyticsSettings Configuration settings
  */
- (void) initialize: (NSString *) screenName productAnalyticsSettings: (YBProductAnalyticsSettings *) productAnalyticsSettings{
    [self initialize: screenName productAnalyticsSettings: productAnalyticsSettings sessionDimensions: nil];
}

/**
  * Initializes product analytics
  * @param screenName Name of the current screen
  * @param productAnalyticsSettings Configuration settings
  * @param sessionDimensions Dimensions to track in the session
  */
- (void) initialize: (NSString *) screenName productAnalyticsSettings: (YBProductAnalyticsSettings *) productAnalyticsSettings sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions{

    YBProductAnalyticsSettings * defaultSettings = [YBProductAnalyticsSettings new];
    
    self._screenName = screenName;

    if ( productAnalyticsSettings == nil ){
        self._productAnalyticsSettings = defaultSettings;
    } else {
        self._productAnalyticsSettings = productAnalyticsSettings;
    }
    
    // Validate settings

    if ( self._productAnalyticsSettings.highlightContentAfter < 1000 ){
        [YBLog warn: @"Invalid highlightContentAfter value. Using default value instead."];
        self._productAnalyticsSettings.highlightContentAfter = defaultSettings.highlightContentAfter;
    }

    if ( self._productAnalyticsSettings.activeStateTimeout < 1000 ){
        [YBLog warn: @"Invalid activeStateTimeout value. Using default value instead."];
        self._productAnalyticsSettings.activeStateTimeout = defaultSettings.activeStateTimeout;
    }

    if ( self._productAnalyticsSettings.activeStateDimension < 1 || self._productAnalyticsSettings.activeStateDimension > 20 ){
        [YBLog warn: @"Invalid activeStateDimension value. Using default value instead."];
        self._productAnalyticsSettings.activeStateDimension = defaultSettings.activeStateDimension;
    }
    
    self._initialized = true;

    // Start session
    
    [self newSession: sessionDimensions];
}

/**
  * Update infinity reference
  */

-(void) setInfinity: (YBInfinity *) infinity{
    self._infinity = infinity;
    
    if ( self._infinity == nil ){
        [YBLog warn: @"Infinity reference unset"];
    }
}

/**
  * Destroy product analytics
  */
- (void) destroy{
    self._options = nil;
    self._infinity = nil;
    self._adapter = nil;

    self._productAnalyticsSettings = [YBProductAnalyticsSettings new];
    self._screenName = @"";

    self._searchQuery = nil;
    self.playerAdapterEventDelegate = nil;

    [self adapterBeforeRemove];
    [self contentFocusOut];

    self._initialized = false;
}

// ------------------------------------------------------------------------------------------------------
// ADAPTER
// ------------------------------------------------------------------------------------------------------

/**
  * Executed after adapter is set to plugin
  */

- (void) adapterAfterSet: (YBPlayerAdapter *) adapter{

    if ( self._initialized ){
        self._adapter = adapter;
        
        // Set active state
        
        if ( self._productAnalyticsSettings.enableStateTracking ){

            if ( self._userState != nil ){
                [YBLog warn: @"userState is already initialized"];
            }

            if ( self._options == nil ){
                [YBLog warn: @"Cannot track user state since plugin options are unavailable"];
            } else {

                self._userState = [[YBProductAnalyticsUserState alloc] initWithActiveStateDimension: self._productAnalyticsSettings.activeStateDimension
                                                                                 activeStateTimeout: self._productAnalyticsSettings.activeStateTimeout
                                                                                   fireEventAdapter:^(NSString *eventName, NSMutableDictionary *dimensionsInternal,
                                                                                                       NSMutableDictionary *dimensionsUser, NSMutableDictionary *metrics) {
                                                                                                            [self fireAdapterEvent: eventName
                                                                                                                dimensionsInternal: dimensionsInternal
                                                                                                                    dimensionsUser: dimensionsUser
                                                                                                                           metrics: metrics];
                                                                                                        }
                                                                                            options: self._options];
            }
        } else if ( self._userState != nil ){

            [self._userState destroy];
            self._userState = nil;

        }
        
        // Track player interaction
        
        if (self._adapter == nil){
            [YBLog warn: @"Cannot bind adapter start since adapter is unavailable"];
        } else {
            [self._adapter addYouboraAdapterDelegate: self.playerAdapterEventDelegate];
        }
    }
}

/**
  * Executed before removing adapter from plugin
  */

- (void) adapterBeforeRemove{

    if ( self._initialized ){

        // Unbind events
            
        if (self._adapter == nil){
            [YBLog warn: @"Cannot unbind adapter start since adapter is unavailable"];
        } else {
            [self._adapter removeYouboraAdapterDelegate: self.playerAdapterEventDelegate];
        }

        if ( self._userState != nil ){
            [self._userState destroy];
            self._userState = nil;
        }

        self._adapter = nil;
        [self releasePlayerEventsPending];
    }
}

// ------------------------------------------------------------------------------------------------------
// SESSION
// ------------------------------------------------------------------------------------------------------

/**
  * New user session
  * @return True if session start has been executed; false otherwise.
  */

- (Boolean) newSession {
    return [self newSession: nil];
}

/**
  * New user session
  * @param sessionDimensions Dimensions to track in the session
  * @return True if session start has been executed; false otherwise.
  */

- (Boolean) newSession: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions {
    Boolean executed = false;

    if ( !self._initialized ){
        [YBLog warn: @"Cannot start a new session since Product Analytics is uninitialized."];
    } else if ( self._infinity == nil ){
        [YBLog warn: @"Cannot start a new session since infinity is unavailable."];
    } else {
        [self._infinity end];
        // TODO: do we have to pass screenName as an argument or use its current value?
        [self._infinity beginWithScreenName: self._screenName andDimensions: sessionDimensions];
        executed = true;
    }
    
    return executed;
}

/**
  * Ends user session
  * @return True if session end has been executed; false otherwise.
  */

- (Boolean) endSession {
    return [self endSession: nil];
}

/**
  * Ends user session
  * @param sessionDimensions Dimensions to track in the session
  * @return True if session end has been executed; false otherwise.
  */

- (Boolean) endSession: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions {
    Boolean executed = false;

    if ( !self._initialized ){
        [YBLog warn: @"Cannot end session since Product Analytics is uninitialized."];
    } else if ( self._infinity == nil ){
        [YBLog warn: @"Cannot end session since infinity is unavailable."];
    } else {
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];

        if (sessionDimensions != nil){
            params[@"dimensions"] = [YBYouboraUtils stringifyDictionary:sessionDimensions];
        }

        [self._infinity end: params];
        executed = true;
    }

    return executed;
}


// ---------------------------------------------------------------------------------------------
// LOGIN / LOGOUT
// ---------------------------------------------------------------------------------------------

/**
 * Login successful
 * @param userId User identifier
 */

- (void) loginSuccessful: (nonnull NSString *) userId {
    [self loginSuccessful:userId dimensions:nil metrics:nil sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param dimensions Dimensions to track
 */

- (void) loginSuccessful: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions {
    [self loginSuccessful:userId dimensions:dimensions metrics:nil sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) loginSuccessful: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {
    [self loginSuccessful:userId dimensions:dimensions metrics:metrics sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 * @param sessionDimensions Dimensions to track in the session
 */

- (void) loginSuccessful: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions {
    if (userId == nil || userId.length == 0) {
        [YBLog warn: @"Cannot log in successfully since userId is unset."];
    } else if ([self checkState: @"log in successfully"]) {
        // Send an event informing that we are closing the session because of a profile change

        [self loginSuccessfulEvent:userId dimensions:dimensions metrics:metrics];

        // Set the userId option and close + open a new session

        [self setUserId:userId];
        [self newSession:sessionDimensions];
    }
}

/**
 * Login successful
 * @param userId User identifier
 * @param profileId Profile identifier
 */

- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId {
    [self loginSuccessful:userId profileId:profileId profileType:nil dimensions:nil metrics:nil sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param profileId Profile identifier
 * @param profileType Profile type
 */

- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType{
    [self loginSuccessful:userId profileId:profileId profileType:profileType dimensions:nil metrics:nil sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 */

- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self loginSuccessful:userId profileId:profileId profileType:profileType dimensions:dimensions metrics:nil sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {
    [self loginSuccessful:userId profileId:profileId profileType:profileType dimensions:dimensions metrics:metrics sessionDimensions:nil];
}

/**
 * Login successful
 * @param userId User identifier
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 * @param sessionDimensions Dimensions to track in the session
 */

- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions {

    if (userId == nil || userId.length == 0) {
        [YBLog warn: @"Cannot log in successfully since userId is unset."];
    } else if (profileId == nil || profileId.length == 0) {
        [YBLog warn: @"Cannot log in successfully since profileId is unset."];
    } else if ([self checkState: @"log in successfully"]) {
        // Send user login event

        [self loginSuccessfulEvent:userId dimensions:dimensions metrics:metrics];

        // Send profile selection event

        [self userProfileSelectedEvent:profileId profileType:profileType dimensions:dimensions metrics:metrics];

        // Set the userId option and close + open a new session

        [self setUserId:userId];
        [self setProfileId:profileId];
        [self newSession:sessionDimensions];
    }
}

/**
 * Send login successful event
 * @param userId User identifier
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) loginSuccessfulEvent: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {
    
    [self fireEvent: @"User Login Successful"
          eventType: eventTypeUser
 dimensionsInternal: @{
                        @"username": userId
                      }
     dimensionsUser: dimensions
            metrics: metrics];
}

/**
 * Login unsuccessful
 */

- (void) loginUnsuccessful {
    [self loginUnsuccessful:nil metrics:nil];
}

/**
 * Login unsuccessful
 * @param dimensions Dimensions to track
 */

- (void) loginUnsuccessful: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self loginUnsuccessful:dimensions metrics:nil];
}

/**
 * Login unsuccessful
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) loginUnsuccessful: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {

    if ([self checkState: @"track log in unsuccessful"]) {
        [self fireEvent: @"User Login Unsuccessful"
              eventType: eventTypeUser
     dimensionsInternal: @{}
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

/**
 * Logout
 */

- (void) logout {
    [self logout:nil metrics:nil sessionDimensions:nil];
}

/**
 * Logout
 * @param dimensions Dimensions to track
 */

- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions {
    [self logout:dimensions metrics:nil sessionDimensions:nil];
}

/**
 * Logout
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {
    [self logout:dimensions metrics:metrics sessionDimensions:nil];
}

/**
 * Logout
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 * @param sessionDimensions Dimensions to track in the session
 */

- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions {

    if ([self checkState: @"log out"]) {
        // Send an event informing that we are closing the session

        [self fireEvent: @"User Logout"
              eventType: eventTypeUser
     dimensionsInternal: @{}
         dimensionsUser: dimensions
                metrics: metrics];


        // Set the userId option and close + open a new session

        [self setUserId:nil];
        [self setProfileId:nil];
        [self newSession:sessionDimensions];
    }
}

// ---------------------------------------------------------------------------------------------
// PROFILE
// ---------------------------------------------------------------------------------------------

/**
 * Create user profile
 * @param profileId Profile identifier
 */

- (void) userProfileCreated: (nonnull NSString *) profileId {
    [self userProfileCreated:profileId profileType:nil dimensions:nil metrics:nil];
}

/**
 * Create user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 */

- (void) userProfileCreated: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType {
    [self userProfileCreated:profileId profileType:profileType dimensions:nil metrics:nil];
}

/**
 * Create user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 */

- (void) userProfileCreated: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions {
    [self userProfileCreated:profileId profileType:profileType dimensions:dimensions metrics:nil];
}

/**
 * Create user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) userProfileCreated: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {

    if (profileId == nil || profileId.length == 0) {
        [YBLog warn: @"Cannot create user profile since profileId is unset."];
    } else if ([self checkState: @"create user profile"]) {

        [self fireEvent: @"User Profile Created"
              eventType: eventTypeUserProfile
     dimensionsInternal: [self getUserProfileDimensions:profileId profileType:profileType]
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

/**
 * Select user profile
 * @param profileId Profile identifier
 */

- (void) userProfileSelected: (nonnull NSString *) profileId {
    [self userProfileSelected:profileId profileType:nil dimensions:nil metrics:nil sessionDimensions:nil];
}


/**
 * Select user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 */

- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType {
    [self userProfileSelected:profileId profileType:profileType dimensions:nil metrics:nil sessionDimensions:nil];
}


/**
 * Select user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 */

- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions {
    [self userProfileSelected:profileId profileType:profileType dimensions:dimensions metrics:nil sessionDimensions:nil];
}

/**
 * Select user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {
    [self userProfileSelected:profileId profileType:profileType dimensions:dimensions metrics:metrics sessionDimensions:nil];
}

/**
 * Select user profile
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 * @param sessionDimensions Dimensions to track in the session 
 */

- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions  {

    if (profileId == nil || profileId.length == 0) {
        [YBLog warn: @"Cannot select user profile since profileId is unset."];
    } else if ([self checkState: @"select user profile"]) {
        // Send an event informing that we are closing the session because of a profile change

        [self userProfileSelectedEvent:profileId profileType:profileType dimensions:dimensions metrics:metrics];

        // Set the profileId option and close + open a new session

        [self setProfileId:profileId];
        [self newSession:sessionDimensions];
    }
}

/**
 * Send user profile selected event
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) userProfileSelectedEvent: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {

        [self fireEvent: @"User Profile Selected"
              eventType: eventTypeUserProfile
     dimensionsInternal: [self getUserProfileDimensions:profileId profileType:profileType]
         dimensionsUser: dimensions
                metrics: metrics];
}


/**
 * Delete user profile
 * @param profileId Profile identifier
 */

- (void) userProfileDeleted: (nonnull NSString *) profileId {
    [self userProfileDeleted:profileId dimensions:nil metrics:nil];
}

/**
 * Delete user profile
 * @param profileId Profile identifier
 * @param dimensions Dimensions to track
 */

- (void) userProfileDeleted: (nonnull NSString *) profileId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions {
    [self userProfileDeleted:profileId dimensions:dimensions metrics:nil];
}

/**
 * Delete user profile
 * @param profileId Profile identifier
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 */

- (void) userProfileDeleted: (nonnull NSString *) profileId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics {

    if (profileId == nil || profileId.length == 0) {
        [YBLog warn: @"Cannot delete user profile since profileId is unset."];
    } else if ([self checkState: @"delete user profile" ]) {

        [self fireEvent: @"User Profile Deleted"
              eventType: eventTypeUserProfile
     dimensionsInternal: [self getUserProfileDimensions:profileId profileType:nil]
         dimensionsUser: dimensions
                metrics: metrics];

    }
}

/**
 * Get user profile dimensions
 * @param profileId Profile identifier
 * @param profileType Profile type
 * @returns
 * @private
 */

- (NSDictionary<NSString *, NSString *> *) getUserProfileDimensions: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType {

    NSMutableDictionary<NSString *, NSString *> * dimensions;

    dimensions = [NSMutableDictionary dictionary];
    dimensions[@"profileId"] = profileId;
    
    if ( profileType != nil ) {
        dimensions[@"profileType"] = profileType;
    }

    return dimensions;
}

// ------------------------------------------------------------------------------------------------------
// NAVIGATION
// ------------------------------------------------------------------------------------------------------

/**
  * Tracks navigation
  * @param screenName The unique name to identify a page of the application.
  */

- (void) trackNavByName: (nonnull NSString *) screenName{

    [self trackNavByName:screenName dimensions:nil metrics:nil];
}
/**
  * Tracks navigation
  * @param screenName The unique name to identify a page of the application.
  * @param  dimensions Dimensions to track
  */

- (void) trackNavByName: (nonnull NSString *) screenName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackNavByName:screenName dimensions:dimensions metrics:nil];
}

/**
  * Tracks navigation
  * @param screenName The unique name to identify a page of the application.
  * @param  dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackNavByName: (nonnull NSString *) screenName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (screenName == nil || screenName.length == 0) {
        [YBLog warn: @"Cannot track navigation since page has not been supplied."];
    } else if ([self checkState: @"track navigation"]) {
        
        self._screenName = [screenName copy];
        
        [self fireEvent: @"paNavigation"
              eventType: eventTypeNavigation
     dimensionsInternal: @{
                            @"paRoute":       @"",
                            @"paRouteDomain": @"",
                            @"paFullRoute":   @"",
                            @"paReferrer":    @""
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// ATTRIBUTION
// ------------------------------------------------------------------------------------------------------

/**
  * Tracks attribution
  * @param utmSource The UTM Source parameter. It is commonly used to identify a search engine, newsletter, or other source (i.e., Google, Facebook, etc.).
  * @param utmMedium The UTM Medium parameter. It is commonly used to identify a medium such as email or cost-per-click (cpc).
  * @param utmCampaign The UTM Campaign parameter. It is commonly used for campaign analysis to identify a specific product promotion or strategic campaign (i.e., spring sale).
  * @param utmTerm The UTM Term parameter. It is commonly used with paid search to supply the keywords for ads (i.e., Customer, NonBuyer, etc.).
  * @param utmContent The UTM Content parameter. It is commonly used for A/B testing and content-targeted ads to differentiate ads or links that point to the same URL (i.e., Banner1, Banner2, etc.)
  */

- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent{
    [self trackAttribution:utmSource utmMedium:utmMedium utmCampaign:utmCampaign utmTerm:utmTerm utmContent:utmContent dimensions:nil metrics:nil];
}

/**
  * Tracks attribution
  * @param utmSource The UTM Source parameter. It is commonly used to identify a search engine, newsletter, or other source (i.e., Google, Facebook, etc.).
  * @param utmMedium The UTM Medium parameter. It is commonly used to identify a medium such as email or cost-per-click (cpc).
  * @param utmCampaign The UTM Campaign parameter. It is commonly used for campaign analysis to identify a specific product promotion or strategic campaign (i.e., spring sale).
  * @param utmTerm The UTM Term parameter. It is commonly used with paid search to supply the keywords for ads (i.e., Customer, NonBuyer, etc.).
  * @param utmContent The UTM Content parameter. It is commonly used for A/B testing and content-targeted ads to differentiate ads or links that point to the same URL (i.e., Banner1, Banner2, etc.)
  * @param dimensions Dimensions to track
  */

- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions {
    [self trackAttribution:utmSource utmMedium:utmMedium utmCampaign:utmCampaign utmTerm:utmTerm utmContent:utmContent dimensions:dimensions metrics:nil];
}

/**
  * Tracks attribution
  * @param utmSource The UTM Source parameter. It is commonly used to identify a search engine, newsletter, or other source (i.e., Google, Facebook, etc.).
  * @param utmMedium The UTM Medium parameter. It is commonly used to identify a medium such as email or cost-per-click (cpc).
  * @param utmCampaign The UTM Campaign parameter. It is commonly used for campaign analysis to identify a specific product promotion or strategic campaign (i.e., spring sale).
  * @param utmTerm The UTM Term parameter. It is commonly used with paid search to supply the keywords for ads (i.e., Customer, NonBuyer, etc.).
  * @param utmContent The UTM Content parameter. It is commonly used for A/B testing and content-targeted ads to differentiate ads or links that point to the same URL (i.e., Banner1, Banner2, etc.)
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    NSMutableDictionary<NSString *, NSString *> * parameters;
    
    parameters = [NSMutableDictionary dictionary];
    
    if ( utmSource   != nil && utmSource.length   > 0 ) parameters[@"utmSource"]   = utmSource;
    if ( utmMedium   != nil && utmMedium.length   > 0 ) parameters[@"utmMedium"]   = utmMedium;
    if ( utmCampaign != nil && utmCampaign.length > 0 ) parameters[@"utmCampaign"] = utmCampaign;
    if ( utmTerm     != nil && utmTerm.length     > 0 ) parameters[@"utmTerm"]     = utmTerm;
    if ( utmContent  != nil && utmContent.length  > 0 ) parameters[@"utmContent"]  = utmContent;

    if (parameters.count == 0) {
        [YBLog warn: @"Cannot track attribution since no arguments have been supplied."];
    } else if ([self checkState: @"track attribution"]) {

        parameters[@"utmUrl"] = @"";

        [self fireEvent: @"Attribution"
              eventType: eventTypeAttribution
     dimensionsInternal: parameters
         dimensionsUser: dimensions
                metrics: metrics];

    }
}

// ------------------------------------------------------------------------------------------------------
// SECTION
// ------------------------------------------------------------------------------------------------------

/**
  * Section goes into viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  */

- (void) trackSectionVisible: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder{
    [self trackSectionVisible:section sectionOrder:sectionOrder dimensions:nil metrics:nil];
}

/**
  * Section goes into viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param dimensions Dimensions to track
  */

- (void) trackSectionVisible: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSectionVisible:section sectionOrder:sectionOrder dimensions:dimensions metrics:nil];
}

/**
  * Section goes into viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSectionVisible: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (section == nil || section.length == 0) {
        [YBLog warn:@"Cannot track section visible since no section has been supplied."];
    } else if (sectionOrder < 1) {
        [YBLog warn:@"Cannot track section visible since sectionOrder is invalid."];
    } else if ([self checkState: @"track section visible"]) {
        [self fireEvent: @"Section Visible"
              eventType: eventTypeSection
     dimensionsInternal: @{
                                 @"section": section,
                            @"sectionOrder": [NSString stringWithFormat:@"%@", @(sectionOrder)]
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

/**
  * Section goes out of viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  */

- (void) trackSectionHidden: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder{
    [self trackSectionHidden:section sectionOrder:sectionOrder dimensions:nil metrics:nil];
}

/**
  * Section goes out of viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param dimensions Dimensions to track
  */

- (void) trackSectionHidden: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSectionHidden:section sectionOrder:sectionOrder dimensions:dimensions metrics:nil];
}

/**
  * Section goes out of viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSectionHidden: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (section == nil || section.length == 0) {
        [YBLog warn:@"Cannot track section hidden since no section has been supplied."];
    } else if (sectionOrder < 1) {
        [YBLog warn:@"Cannot track section hidden since sectionOrder is invalid."];
    } else if ([self checkState: @"track section hidden"]) {
        [self fireEvent: @"Section Hidden"
              eventType: eventTypeSection
     dimensionsInternal: @{
                                 @"section":   section,
                            @"sectionOrder": [NSString stringWithFormat:@"%@", @(sectionOrder)]
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// CONTENT
// ------------------------------------------------------------------------------------------------------

/**
  * Sends a content highlight event if content is focused during, at least, highlightContentAfter ms.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  */

- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId{
    [self contentFocusIn:section sectionOrder:sectionOrder column:column row:row contentId:contentId dimensions:nil metrics:nil];
}

/**
  * Sends a content highlight event if content is focused during, at least, highlightContentAfter ms.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  * @param dimensions Dimensions to track
  */

- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self contentFocusIn:section sectionOrder:sectionOrder column:column row:row contentId:contentId dimensions:dimensions metrics:nil];
}

/**
  * Sends a content highlight event if content is focused during, at least, highlightContentAfter ms.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    
    [self contentFocusOut];

    if (section == nil || section.length == 0) {
        [YBLog warn:@"Cannot track content highlight since no section has been supplied."];
    } else if (sectionOrder < 1) {
        [YBLog warn:@"Cannot track content highlight since sectionOrder is invalid."];
    } else if (column < 1) {
        [YBLog warn:@"Cannot track content highlight since column is invalid"];
    } else if (row < 1) {
        [YBLog warn:@"Cannot track content highlight since row is invalid"];
    } else if (contentId == nil || contentId.length == 0) {
        [YBLog warn:@"Cannot track content highlight since no contentId has been supplied."];
    } else if ([self checkState: @"track content highlight"]) {

        float interval = self._productAnalyticsSettings.highlightContentAfter / 1000.0;
        NSMutableDictionary<NSString *, id> * contentHighlighted = [NSMutableDictionary dictionary];
        [contentHighlighted setObject: section forKey:@"section" ];
        [contentHighlighted setObject: [NSString stringWithFormat:@"%@", @(sectionOrder)] forKey:@"sectionOrder" ];
        [contentHighlighted setObject: [NSString stringWithFormat:@"%@", @(column)] forKey:@"column" ];
        [contentHighlighted setObject: [NSString stringWithFormat:@"%@", @(row)] forKey:@"row" ];
        [contentHighlighted setObject: contentId forKey:@"contentId" ];

        if ( dimensions != nil ){
            [contentHighlighted setObject: dimensions forKey: @"dimensions"];
        }

        if ( metrics != nil ){
            [contentHighlighted setObject: metrics forKey: @"metrics"];
        }

        self._contentHighlightTimeout = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector: @selector(trackContentHighlight:) userInfo: contentHighlighted repeats: NO];
    }
}

/**
  * Content loses focus
  */

- (void) contentFocusOut{

    if ( self._contentHighlightTimeout != nil ){
        [self._contentHighlightTimeout invalidate];
        self._contentHighlightTimeout = nil;
    }
}

/**
  * Sends a content highlight event using selected content info
  * @private
  */

- (void) trackContentHighlight:(NSTimer *)timer {

    NSDictionary * contentHighlighted = timer.userInfo;

    if ( contentHighlighted == nil ){
        [YBLog warn:@"Cannot track content highlight since no content is selected."];
    } else {
        [self fireEvent: @"Section Content Highlight"
              eventType: eventTypeSection
     dimensionsInternal: @{
                                 @"section": contentHighlighted[@"section"],
                            @"sectionOrder": contentHighlighted[@"sectionOrder"],
                                  @"column": contentHighlighted[@"column"],
                                     @"row": contentHighlighted[@"row"],
                               @"contentId": contentHighlighted[@"contentId"]
                          }
         dimensionsUser: contentHighlighted[@"dimensions"]
                metrics: contentHighlighted[@"metrics"]];
    }
    
}

/**
  * Tracks the location of user clicks.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  */

- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId{
    [self trackContentClick:section sectionOrder:sectionOrder column:column row:row contentId:contentId dimensions:nil metrics:nil];
}

/**
  * Tracks the location of user clicks.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  * @param dimensions Dimensions to track
  */

- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackContentClick:section sectionOrder:sectionOrder column:column row:row contentId:contentId dimensions:dimensions metrics:nil];
}

/**
  * Tracks the location of user clicks.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (section == nil || section.length == 0) {
        [YBLog warn:@"Cannot track content click since no section has been supplied."];
    } else if (sectionOrder < 1) {
        [YBLog warn:@"Cannot track content click since sectionOrder is invalid."];
    } else if (column < 1) {
        [YBLog warn:@"Cannot track content click since column is invalid."];
    } else if (row < 1) {
        [YBLog warn:@"Cannot track content click since row is invalid."];
    } else if (contentId == nil || contentId.length == 0) {
        [YBLog warn:@"Cannot track content click since no contentId has been supplied."];
    } else if ([self checkState: @"track content click"]) {
        [self fireEvent: @"Section Content Click"
              eventType: eventTypeSection
     dimensionsInternal: @{
                                 @"section": section,
                            @"sectionOrder": [NSString stringWithFormat:@"%@", @(sectionOrder)],
                                  @"column": [NSString stringWithFormat:@"%@", @(column)],
                                     @"row": [NSString stringWithFormat:@"%@", @(row)],
                               @"contentId": contentId
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// CONTENT PLAYBACK
// ------------------------------------------------------------------------------------------------------

/**
  * Tracks when a content starts playing be it automatically or through a user interaction.
  * @param contentId The unique content identifier of the content being played.
  */

- (void) trackPlay: (nonnull NSString *) contentId{
    [self trackPlay:contentId dimensions:nil metrics:nil];
}

/**
  * Tracks when a content starts playing be it automatically or through a user interaction.
  * @param contentId The unique content identifier of the content being played.
  * @param dimensions Dimensions to track
  */

- (void) trackPlay: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackPlay:contentId dimensions:dimensions metrics:nil];
}

/**
  * Tracks when a content starts playing be it automatically or through a user interaction.
  * @param contentId The unique content identifier of the content being played.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackPlay: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    NSString * eventName = @"Content Play";
    Boolean startEvent = false;

    if (contentId == nil || contentId.length == 0) {
        [YBLog warn:@"Cannot track play since no contentId has been supplied."];
    } else if (self._adapter == nil) {
        [YBLog warn:@"Cannot track play since adapter is unset."];
    } else if ([self checkState: @"track play"]) {

        if (self._adapter.flags.started) {
            // Start event already sent...

            // ... send pending events

            [self trackPlayerEventsPending];

            // ... send current event

            [self trackPlayerEvent: eventName
                         contentId: contentId
                        dimensions: dimensions
                           metrics: metrics
                        startEvent: startEvent];
        } else {
            // Start event not sent yet: add event to the pending queue
            
            [self addPlayerEventPending:eventName contentId:contentId dimensions:dimensions metrics:metrics startEvent:startEvent];
        }

    }
}

/**
  * Tracks content watching events.
  * TODO: add (2nd) argument to tell whether user state must be updated or not
  * @param eventName The name of the interaction (i.e., Pause, Seek, Skip Intro, Skip Ads, Switch Language, etc.).
  */

- (void) trackPlayerInteraction: (nonnull NSString *) eventName{
    [self trackPlayerInteraction:eventName dimensions:nil metrics:nil];
}

/**
  * Tracks content watching events.
  * TODO: add (2nd) argument to tell whether user state must be updated or not
  * @param eventName The name of the interaction (i.e., Pause, Seek, Skip Intro, Skip Ads, Switch Language, etc.).
  */

- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackPlayerInteraction:eventName dimensions:dimensions metrics:nil];
}

/**
  * Tracks content watching events.
  * TODO: add (2nd) argument to tell whether user state must be updated or not
  * @param eventName The name of the interaction (i.e., Pause, Seek, Skip Intro, Skip Ads, Switch Language, etc.).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    [self trackPlayerInteraction:eventName dimensions:dimensions metrics:metrics startEvent:false];
}

/**
  * Tracks content watching events.
  * @param eventName The name of the interaction (i.e., Pause, Seek, Skip Intro, Skip Ads, Switch Language, etc.).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  * @param startEvent Internal param informing that current interaction is responsible of first player start
  */

- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics startEvent: (Boolean) startEvent{
    NSString * eventNameFull;
    NSString * contentId = nil;

    if (eventName == nil || eventName.length == 0) {
        [YBLog warn:@"Cannot track player interaction since no interaction name has been supplied."];
    } else if (self._adapter == nil) {
        [YBLog warn:@"Cannot track player interaction since adapter is unset."];
    } else if ([self checkState: @"track player interaction"]) {
        
        eventNameFull = [@"Content Play " stringByAppendingString:eventName];
        
        if (self._adapter.flags.started) {
            // Start event already sent...

            // ... send pending events
            
            [self trackPlayerEventsPending];

            // ... send current event

            [self trackPlayerEvent: eventNameFull
                         contentId: contentId
                        dimensions: dimensions
                           metrics: metrics
                        startEvent: startEvent];

        } else {
            // Start event not sent yet: add event to the pending queue
            
            [self addPlayerEventPending:eventNameFull contentId:contentId dimensions:dimensions metrics:metrics startEvent:startEvent];
        }
    }
}

/**
 * Add event to the pending event list
 */

- (void)addPlayerEventPending:(nonnull NSString *)eventName
                    contentId:(nullable NSString *)contentId
                   dimensions:(nullable NSDictionary<NSString *, NSString *> *)dimensions
                      metrics:(nullable NSDictionary<NSString *, NSNumber *> *)metrics
                   startEvent:(Boolean)startEvent {
    @synchronized (self.pendingVideoEvents) {
        YBPendingVideoEvent *event = [[YBPendingVideoEvent alloc] initWithEventName:eventName
                                                                          contentId:contentId
                                                                         dimensions:dimensions
                                                                            metrics:metrics
                                                                         startEvent:startEvent];
        [self.pendingVideoEvents addObject:event];
    }
}

/**
 * Track player pending events
 */

-(void) trackPlayerEventsPending {
    NSMutableArray<YBPendingVideoEvent *> *eventList = [[NSMutableArray alloc] init];

    // Synchronize and create a local copy of the event queue

    @synchronized (self.pendingVideoEvents) {

        if (self.pendingVideoEvents != nil && self.pendingVideoEvents.count > 0) {

            // Create a local copy of the event list to prevent concurrency issues
            
            for (YBPendingVideoEvent *event in self.pendingVideoEvents) {
                YBPendingVideoEvent *eventCopy = [event copy];
                [eventList addObject:eventCopy];
            }

            // Release the source event list
            
            [self releasePlayerEventsPending];
        }
    }

    // Process the local copy safely

    for (YBPendingVideoEvent *event in eventList) {
        if (event && event.eventName ) {
            [self trackPlayerEvent:event.eventName
                         contentId:event.contentId
                        dimensions:event.dimensions
                           metrics:event.metrics
                        startEvent:event.startEvent];
        } else {
            [YBLog warn:@"Skipping invalid or incomplete event."];
        }
        [event destroy];
    }
}

/**
 * Track player pending events
 */

-(void) releasePlayerEventsPending{
    @synchronized (self.pendingVideoEvents) {
        for (YBPendingVideoEvent *event in self.pendingVideoEvents) {
            [event destroy];
        }
        [self.pendingVideoEvents removeAllObjects];
    }
}

/**
 * Track player event
 * @param eventName The name of the interaction (i.e., Pause, Seek, Skip Intro, Skip Ads, Switch Language, etc.).
 * @param contentId The unique content identifier of the content being played.
 * @param dimensions Dimensions to track
 * @param metrics Metrics to track
 * @param startEvent Video start event
 */
-(void) trackPlayerEvent: (nonnull NSString *) eventName contentId: (nullable NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics startEvent: (Boolean) startEvent{
                        
    NSMutableDictionary<NSString *, NSString *> * dimensionsInternal;
    
    dimensionsInternal = [NSMutableDictionary dictionary];

    if ( contentId != nil ){
        [dimensionsInternal setValue:contentId forKey:@"contentId"];
    }

    [self fireAdapterEvent: eventName
        dimensionsInternal: dimensionsInternal
            dimensionsUser: dimensions
                   metrics: metrics];

    if ( self._userState != nil && !startEvent ){
        [self._userState setActive: eventName];
    }
}

// ------------------------------------------------------------------------------------------------------
// CONTENT SEARCH
// ------------------------------------------------------------------------------------------------------

/**
  * Tracks search query events.
  * @param searchQuery The search term entered by the user.
  */

- (void) trackSearchQuery: (nonnull NSString *) searchQuery{
    [self trackSearchQuery:searchQuery dimensions:nil metrics:nil];
}

/**
  * Tracks search query events.
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  */

- (void) trackSearchQuery: (nonnull NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSearchQuery:searchQuery dimensions:dimensions metrics:nil];
}

/**
  * Tracks search query events.
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSearchQuery: (nonnull NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (searchQuery == nil || searchQuery.length == 0) {
        [YBLog warn:@"Cannot track search query since no searchQuery has been supplied."];
    } else if ([self checkState: @"track search query"]) {
        self._searchQuery = searchQuery;

        [self fireEvent: @"Search Query"
              eventType: eventTypeSearch
     dimensionsInternal: @{
                            @"query": self._searchQuery
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

/**
  * Tracks search result events.
  * @param resultCount The number of search results returned by a search query.
  * @param searchQuery The search term entered by the user.
  */

- (void) trackSearchResult: (NSInteger) resultCount searchQuery: (nullable NSString *) searchQuery{
    [self trackSearchResult:resultCount searchQuery:searchQuery dimensions:nil metrics:nil];
}

/**
  * Tracks search result events.
  * @param resultCount The number of search results returned by a search query.
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  */

- (void) trackSearchResult: (NSInteger) resultCount searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSearchResult:resultCount searchQuery:searchQuery dimensions:dimensions metrics:nil];
}

/**
  * Tracks search result events.
  * @param resultCount The number of search results returned by a search query.
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSearchResult: (NSInteger) resultCount searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (resultCount < 0) {
        [YBLog warn:@"Cannot track search result since resultCount is invalid."];
    } else if ([self checkState: @"track search result"]) {

        NSString * query = ( searchQuery != nil && searchQuery.length > 0 ? searchQuery : self._searchQuery );

        [self fireEvent: @"Search Results"
              eventType: eventTypeSearch
     dimensionsInternal: @{
                            @"query":       query,
                            @"resultCount": [NSString stringWithFormat:@"%ld", resultCount]
                          }
         dimensionsUser: dimensions
                metrics: metrics];

    }
}

/**
  * Tracks user interactions with search results.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column The content placement column. It is commonly used to indicate the column number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param row The content placement row. It is commonly used to indicate the row number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param contentId The content identifier. It is used for internal content unequivocally identification (i.e., AAA000111222).
  * @param searchQuery The search term entered by the user.
  */

- (void) trackSearchClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (nullable NSString *) searchQuery{
    [self trackSearchClick:section sectionOrder:sectionOrder column:column row:row contentId:contentId searchQuery:searchQuery dimensions:nil metrics:nil];
}

/**
  * Tracks user interactions with search results.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column The content placement column. It is commonly used to indicate the column number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param row The content placement row. It is commonly used to indicate the row number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param contentId The content identifier. It is used for internal content unequivocally identification (i.e., AAA000111222).
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  */

- (void) trackSearchClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSearchClick:section sectionOrder:sectionOrder column:column row:row contentId:contentId searchQuery:searchQuery dimensions:dimensions metrics:nil];
}

/**
  * Tracks user interactions with search results.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param sectionOrder The section order within the page.
  * @param column The content placement column. It is commonly used to indicate the column number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param row The content placement row. It is commonly used to indicate the row number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param contentId The content identifier. It is used for internal content unequivocally identification (i.e., AAA000111222).
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSearchClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (column < 1) {
        [YBLog warn:@"Cannot track search click since column is invalid."];
    } else if (row < 1) {
        [YBLog warn:@"Cannot track search click since row is invalid."];
    } else if (contentId == nil || contentId.length == 0) {
        [YBLog warn:@"Cannot track search click since no contentId has been supplied."];
    } else if ([self checkState: @"track search click"]) {
        NSString * query;
        
        query = ( searchQuery != nil && searchQuery.length > 0 ? searchQuery : self._searchQuery );

        if ( section.length == 0 ){
            section = @"Search";
        }

        if ( sectionOrder < 1 ){
            sectionOrder = 1;
        }

        [self fireEvent: @"Search Result Click"
              eventType: eventTypeSearch
     dimensionsInternal: @{
                            @"query":        query,
                            @"section":      section,
                            @"sectionOrder": [NSString stringWithFormat:@"%@", @(sectionOrder)],
                            @"column":       [NSString stringWithFormat:@"%ld", column],
                            @"row":          [NSString stringWithFormat:@"%ld", row],
                            @"contentId":    contentId
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// EXTERNAL APPLICATIONS
// ------------------------------------------------------------------------------------------------------

/**
  * Tracks external app start events.
  * @param appName The name of the application being used to deliver the content to the end-user (i.e., Netflix).
  */

- (void) trackExternalAppLaunch: (nonnull NSString *) appName{
    [self trackExternalAppLaunch:appName dimensions:nil metrics:nil];
}

/**
  * Tracks external app start events.
  * @param appName The name of the application being used to deliver the content to the end-user (i.e., Netflix).
  * @param dimensions Dimensions to track
  */

- (void) trackExternalAppLaunch: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackExternalAppLaunch:appName dimensions:dimensions metrics:nil];
}

/**
  * Tracks external app start events.
  * @param appName The name of the application being used to deliver the content to the end-user (i.e., Netflix).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackExternalAppLaunch: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (appName == nil || appName.length == 0) {
        [YBLog warn:@"Cannot track external application launch since no appName has been supplied."];
    } else if ([self checkState: @"track external application launch"]) {
        [self fireEvent: @"External Application Launch"
              eventType: eventTypeExternalApplication
     dimensionsInternal: @{
                            @"paExtAppName": appName
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

/**
  * Tracks external app stop events.
  * @param appName The name of the application being used to deliver the content to the end-user (i.e., Netflix).
  */

- (void) trackExternalAppExit: (nonnull NSString *) appName{
    [self trackExternalAppExit:appName dimensions:nil metrics:nil];
}

/**
  * Tracks external app stop events.
  * @param appName The name of the application being used to deliver the content to the end-user (i.e., Netflix).
  * @param dimensions Dimensions to track
  */

- (void) trackExternalAppExit: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackExternalAppExit:appName dimensions:dimensions metrics:nil];
}

/**
  * Tracks external app stop events.
  * @param appName The name of the application being used to deliver the content to the end-user (i.e., Netflix).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackExternalAppExit: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (appName == nil || appName.length == 0) {
        [YBLog warn:@"Cannot track external application exit since no appName has been supplied."];
    } else if ([self checkState: @"track external application exit"]) {
        [self fireEvent: @"External Application Exit"
              eventType: eventTypeExternalApplication
     dimensionsInternal: @{
                            @"paExtAppName": appName
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// ENGAGEMENT
// ------------------------------------------------------------------------------------------------------

/**
  * Tracks engagement events.
  * @param eventName The name of the engagement event (i.e., Share, Save, Rate, etc.).
  * @param contentId The unique content identifier of the content the user is engaging with.
  */

- (void) trackEngagementEvent: (nonnull NSString *) eventName contentId: (nonnull NSString *) contentId{
    [self trackEngagementEvent:eventName contentId:contentId dimensions:nil metrics:nil];
}

/**
  * Tracks engagement events.
  * @param eventName The name of the engagement event (i.e., Share, Save, Rate, etc.).
  * @param contentId The unique content identifier of the content the user is engaging with.
  * @param dimensions Dimensions to track
  */

- (void) trackEngagementEvent: (nonnull NSString *) eventName contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackEngagementEvent:eventName contentId:contentId dimensions:dimensions metrics:nil];
}

/**
  * Tracks engagement events.
  * @param eventName The name of the engagement event (i.e., Share, Save, Rate, etc.).
  * @param contentId The unique content identifier of the content the user is engaging with.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackEngagementEvent: (nonnull NSString *) eventName contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    
    if (eventName == nil || eventName.length == 0) {
        [YBLog warn:@"Cannot track engagement event since no eventName has been supplied."];
    } else if (contentId == nil || contentId.length == 0) {
        [YBLog warn:@"Cannot track engagement event since no contentId has been supplied."];
    } else if ([self checkState: @"track engagement event"]) {
        [self fireEvent: [@"Engagement " stringByAppendingString:eventName]
              eventType: eventTypeEngagement
     dimensionsInternal: @{
                            @"contentId": contentId
                          }
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// CUSTOM EVENT
// ------------------------------------------------------------------------------------------------------

/**
  * Track custom event
  * @param eventName Name of the event to track
  */

- (void) trackEvent: (nonnull NSString *) eventName{
    [self trackEvent:eventName dimensions:nil metrics:nil];
}

/**
  * Track custom event
  * @param eventName Name of the event to track
  * @param dimensions Dimensions to track
  */

- (void) trackEvent: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackEvent:eventName dimensions:dimensions metrics:nil];
}

/**
  * Track custom event
  * @param eventName Name of the event to track
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackEvent: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions  metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if (eventName == nil || eventName.length == 0) {
        [YBLog warn:@"Cannot track custom event since no eventName has been supplied."];
    } else if ([self checkState: @"track custom event"]) {
        [self fireEvent: [@"Custom " stringByAppendingString: eventName]
              eventType: eventTypeCustom
     dimensionsInternal: @{}
         dimensionsUser: dimensions
                metrics: metrics];
    }
}

// ------------------------------------------------------------------------------------------------------
// INTERNAL
// ------------------------------------------------------------------------------------------------------

/**
  * Fires an event
  * @param eventName Name of the event to be fired
  * @param dimensionsInternal Dimensions supplied by user
  * @param dimensionsUser Specific event dimensions
  * @param metrics Metrics to track
  * @private
  */

- (Boolean) fireEvent: (nonnull NSString *) eventName eventType: (EventTypes) eventType dimensionsInternal: (nullable NSDictionary<NSString *, NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *, NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    
    NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> * dimensions;
    Boolean fired;

    [YBLog notice: eventName];

    if ( self._infinity == nil ){

        [YBLog warn:@"Cannot fire %@ since infinity is unavailable.", eventName];
        fired = false;

    } else {

        dimensions = [self buildDimensions: eventType
                        dimensionsInternal: dimensionsInternal
                            dimensionsUser: dimensionsUser];

        [self._infinity fireEvent: eventName
                       dimensions: dimensions[@"custom"]
                           values: metrics
               topLevelDimensions: dimensions[@"top"]];

        fired = true;
    }
    
    return fired;
}

/**
  * Fires an adapter event (in case it is available)
  * @param eventName Event name
  * @param dimensionsInternal Dimensions supplied by user
  * @param dimensionsUser Specific event dimensions
  * @param metrics Metrics to track
  * @private
  */

- (Boolean)fireAdapterEvent:(nonnull NSString *)eventName dimensionsInternal: (nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *,NSNumber *> *) metrics{

    NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> * dimensions;
    Boolean fired;
    
    [YBLog notice: eventName];
    
    if ( self._adapter == nil ){

        [YBLog warn:@"Cannot fire %@ since adapter is unavailable.", eventName];
        fired = false;
        
    } else {

        dimensions = [self buildDimensions: eventTypeContentPlayback
                        dimensionsInternal: dimensionsInternal
                            dimensionsUser: dimensionsUser];

        [self._adapter fireEventWithName: eventName
                              dimensions: dimensions[@"custom"]
                                  values: metrics
                      topLevelDimensions: dimensions[@"top"]];

        fired = true;
    }

    return fired;
}

/**
  * Builds a list of top level and custom dimensions
  * @param dimensionsInternal Object containing list of internal dimensions
  * @param dimensionsUser Object containing list of custom dimensions
  * @private
  */

- (NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> *)buildDimensions: (EventTypes) eventType dimensionsInternal: (nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser{
    
    NSMutableDictionary <NSString *, NSString *> * dimensionsTopLevel;
    NSMutableDictionary <NSString *, NSString *> * dimensionsCustom;
    NSString * eventTypeString;
    NSArray * dimensionsTopLevelKeys;

    dimensionsCustom = [NSMutableDictionary dictionary];
    dimensionsCustom[@"paPage"] = self._screenName;
    
    if ( dimensionsInternal != nil ){
        [dimensionsCustom addEntriesFromDictionary: dimensionsInternal];
    }

    if ( dimensionsUser != nil ){
        [dimensionsCustom addEntriesFromDictionary: dimensionsUser];
    }

    switch (eventType)
    {
        case eventTypeUserProfile:
            eventTypeString = @"User Profile";
            break;
        case eventTypeUser:
            eventTypeString = @"User";
            break;
        case eventTypeNavigation:
            eventTypeString = @"Navigation";
            break;
        case eventTypeAttribution:
            eventTypeString = @"Attribution";
            break;
        case eventTypeSection:
            eventTypeString = @"Section";
            break;
        case eventTypeContentPlayback:
            eventTypeString = @"Content Playback";
            break;
        case eventTypeSearch:
            eventTypeString = @"Search";
            break;
        case eventTypeExternalApplication:
            eventTypeString = @"External Application";
            break;
        case eventTypeEngagement:
            eventTypeString = @"Engagement";
            break;
        case eventTypeCustom:
            eventTypeString = @"Custom Event";
            break;
        default:
            eventTypeString = @"Unknown";
            break;
    }
    
    dimensionsCustom[@"eventSource"] = @"Product Analytics";
    dimensionsCustom[@"eventType"] = [eventTypeString copy];
    
    // List of Top Level Dimensions
    
    dimensionsTopLevelKeys = @[@"contentid", @"contentId", @"contentID", @"utmSource", @"utmMedium", @"utmCampaign", @"utmTerm", @"utmContent", @"profileId", @"profile_id", @"username"];

    // Create object with top level dimensions
    
    dimensionsTopLevel = [NSMutableDictionary dictionary];
    
    for (NSString * key in dimensionsCustom){
        if ( [dimensionsTopLevelKeys containsObject: key] ){
            dimensionsTopLevel[key] = dimensionsCustom[key];
        }
    }
    
    // Remove top level dimensions from custom dimensions list
    
    for (NSString * key in dimensionsTopLevelKeys){
        [dimensionsCustom removeObjectForKey: key];
    }
    
    return @{@"custom": dimensionsCustom, @"top": dimensionsTopLevel};
}

/**
 * Check state before sending an event
 */

- (Boolean) checkState: (nonnull NSString *) message{
    Boolean valid;

    if ( !self._initialized ) {
        valid = false;
        [YBLog warn: [NSString stringWithFormat: @"Cannot %@ since Product Analytics is uninitialized.", message]];
    } else if ( self._infinity == nil ){
        valid = false;
        [YBLog warn: [NSString stringWithFormat: @"Cannot %@ since infinity is unavailable.", message]];
    } else if ( !self._infinity.flags.started ){
        valid = false;
        [YBLog warn: [NSString stringWithFormat: @"Cannot %@ since session is closed.", message]];
    } else {
        valid = true;
    }

    return valid;
}

/**
 * Set userId
 */

- (void) setUserId: (NSString *) userId{
    if ( self._options == nil ){
        [YBLog warn: @"Cannot set userId since options are unavailable."];
    } else {
        [self._options setValue:userId forKey:@"username"];
    }
}

/**
 * Set profileId
 */

- (void) setProfileId: (NSString *) profileId{
    if ( self._options == nil ){
        [YBLog warn: @"Cannot set profileId since options are unavailable."];
    } else {
        [self._options setValue:profileId forKey:@"profileId"];
    }
}

@end
