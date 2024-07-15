//
//  YBProductAnalytics.m
//  YouboraLib
//
//  Created by Francisco Expósito on 06-02-2024.
//  Copyright © 2024 NPAW. All rights reserved.
//

#import "YBProductAnalytics.h"
#import "YBLog.h"

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
 * @param adapter the adapter taht is firing the event
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

/** Adapter deteccted a successful ad manifest request
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
// YBProductAnalytics
// ---------------------------------------------------------------------------------------------


// Private attribute and method definition

@interface YBProductAnalytics ()

@property(nonatomic, strong) YBProductAnalyticsPlayerAdapterEventDelegate * playerAdapterEventDelegate;

- (void) trackContentHighlight:(NSTimer *)timer;

- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics playerStarted: (Boolean) playerStarted;

- (Boolean) fireEvent: (nonnull NSString *) screenName dimensionsInternal: (nullable NSDictionary<NSString *, NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *, NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (Boolean)fireAdapterEvent:(nonnull NSString *)eventName dimensionsInternal: (nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *,NSNumber *> *) metrics;

- (NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> * _Nonnull)buildDimensions:(nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser;

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
                [self trackPlayerInteraction: @"start" dimensions: @{} metrics: @{} playerStarted: true];
            }
        }];

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

    YBProductAnalyticsSettings * defaultSettings = [YBProductAnalyticsSettings new ];
    
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
}

/**
  * Destroy product analytics
  */
- (void) destroy{
    self._options = nil;
    self._infinity = nil;
    self._adapter = nil;

    self._productAnalyticsSettings = nil;
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
        } else {
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
            [self._userState dispose];
            self._userState = nil;
        }
        
        self._adapter = nil;

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
    Boolean executed = false;

    if ( !self._initialized ){
        [YBLog warn: @"Cannot start a new session since Product Analytics is uninitialized."];
    } else if ( !self._infinity ){
        [YBLog warn: @"Cannot start a new session since infinity is unavailable."];
    } else {
        [self._infinity end];
        // TODO: do we have to pass screenName as an argument or use its current value?
        [self._infinity beginWithScreenName: self._screenName];
        executed = true;
    }
    
    return executed;
}

/**
  * Ends user session
  * @return True if session end has been executed; false otherwise.
  */

- (Boolean) endSession {
    Boolean executed = false;

    if ( !self._initialized ){
        [YBLog warn: @"Cannot end session since Product Analytics is uninitialized."];
    } else if ( !self._infinity ){
        [YBLog warn: @"Cannot end session since infinity is unavailable."];
    } else {
        [self._infinity end];
        executed = true;
    }

    return executed;
}

/**
  * Set user profile
  * @param profileId Profile unique identifer
  */

- (void) setUserProfile: (nonnull NSString *) profileId{
    [self setUserProfile:profileId profileType:nil dimensions:nil metrics:nil];
}

/**
  * Set user profile
  * @param profileId Profile unique identifer
  * @param profileType Type of the profile being set (i.e: kid, adult...)
  */

- (void) setUserProfile: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType{
    [self setUserProfile:profileId profileType:profileType dimensions:nil metrics:nil];
}

/**
  * Set user profile
  * @param profileId Profile unique identifer
  * @param profileType Type of the profile being set (i.e: kid, adult...)
  * @param  dimensions Dimensions to track
  */

- (void) setUserProfile: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self setUserProfile:profileId profileType:profileType dimensions:dimensions metrics:nil];
}

/**
  * Set user profile
  * @param profileId Profile unique identifer
  * @param profileType Type of the profile being set (i.e: kid, adult...)
  * @param  dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) setUserProfile: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if ( !self._initialized ) {
        [YBLog warn: @"Cannot set user profile since Product Analytics is uninitialized."];
    } else if ( !self._infinity ){
        [YBLog warn: @"Cannot set user profile since infinity is unavailable."];
    } else if (profileId.length == 0 ) {
        [YBLog warn: @"Cannot set user profile since profileId is unset."];
    } else {

        NSMutableDictionary<NSString *, NSString *> * dimensionsInternal;

        [self endSession];
        [self newSession];

        dimensionsInternal = [NSMutableDictionary dictionary];
        dimensionsInternal[@"eventType"] = @"UserSwitch";
        dimensionsInternal[@"profileId"] = profileId;

        if (profileType != nil) {
            dimensionsInternal[@"profileType"] = profileType;
        }

        [self fireEvent: @"USER PROFILE SELECTION"
     dimensionsInternal: dimensionsInternal
         dimensionsUser: dimensions
                metrics: metrics];
    }
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

    if ( !self._initialized ){
        [YBLog warn: @"Cannot track navigation since Product Analytics is uninitialized."];
    } else if ( screenName.length == 0 ){
        [YBLog warn: @"Cannot track navigation since page has not been supplied."];
    } else if ( !self._infinity ){
        [YBLog warn: @"Cannot track navigation since Infinity is unavailable."];
    } else {
        
        self._screenName = [screenName copy];
        
        [self._infinity beginWithScreenName:screenName andDimensions:@{
            @"route": @"",
            @"page": screenName
        }];

        [YBLog notice: @"[NAV] %@", self._screenName];
        
        [self fireEvent: [@"[NAV] " stringByAppendingString: self._screenName]
     dimensionsInternal: @{
                            @"eventType":   @"Navigation",
                            @"route":       @"",
                            @"routeDomain": @"",
                            @"fullRoute":   @""
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
    
    if ( utmSource.length > 0 ) parameters[@"utmSource"] = utmSource;
    if ( utmMedium   != nil && utmMedium.length   > 0 ) parameters[@"utmMedium"]   = utmMedium;
    if ( utmCampaign != nil && utmCampaign.length > 0 ) parameters[@"utmCampaign"] = utmCampaign;
    if ( utmTerm     != nil && utmTerm.length     > 0 ) parameters[@"utmTerm"]     = utmTerm;
    if ( utmContent  != nil && utmContent.length  > 0 ) parameters[@"utmContent"]  = utmContent;

    if ( !self._initialized ){
        [YBLog warn: @"Cannot track attribution since Product Analytics is uninitialized."];
    } else if ( parameters.count == 0 ){
        [YBLog warn: @"Cannot track attribution since no arguments have been supplied."];
    } else {

        parameters[@"eventType"] = @"Attribution";
        parameters[@"url"]       = @"";

        [YBLog notice: @"ATTRIBUTION"];

        [self fireEvent: @"ATTRIBUTION"
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
  */

- (void) trackSectionIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder{
    [self trackSectionIn:section sectionOrder:sectionOrder dimensions:nil metrics:nil];
}

/**
  * Section goes into viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param dimensions Dimensions to track
  */

- (void) trackSectionIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSectionIn:section sectionOrder:sectionOrder dimensions:dimensions metrics:nil];
}

/**
  * Section goes into viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSectionIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track section-in since Product Analytics is uninitialized."];
    } else if ( section.length == 0 ){
        [YBLog warn:@"Cannot track section-in since no section has been supplied."];
    } else if ( sectionOrder < 1 ){
        [YBLog warn:@"Cannot track section-in since sectionOrder is invalid."];
    } else {
        [YBLog notice: @"[SECTION] In"];

        [self fireEvent: @"SECTION IN"
     dimensionsInternal: @{
                               @"eventType": @"SectionVisibility",
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
  */

- (void) trackSectionOut: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder{
    [self trackSectionOut:section sectionOrder:sectionOrder dimensions:nil metrics:nil];
}

/**
  * Section goes out of viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param dimensions Dimensions to track
  */

- (void) trackSectionOut: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSectionOut:section sectionOrder:sectionOrder dimensions:dimensions metrics:nil];
}

/**
  * Section goes out of viewport.
  * @param section The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSectionOut: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track section-out since Product Analytics is uninitialized."];
    } else if ( section.length == 0 ){
        [YBLog warn:@"Cannot track section-out since no section has been supplied."];
    } else if ( sectionOrder < 1 ){
        [YBLog warn:@"Cannot track section-out since sectionOrder is invalid."];
    } else {

        [YBLog notice: @"[SECTION] Out"];

        [self fireEvent: @"SECTION OUT"
     dimensionsInternal: @{
                               @"eventType": @"SectionVisibility",
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
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    
    [self contentFocusOut];

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track content highlight since Product Analytics is uninitialized."];
    } else if ( section.length == 0 ){
        [YBLog warn:@"Cannot track content highlight since no section has been supplied."];
    } else if ( sectionOrder < 1 ){
        [YBLog warn:@"Cannot track content highlight since sectionOrder is invalid."];
    } else if ( column < 1 ) {
        [YBLog warn:@"Cannot track content highlight since column is invalid"];
    } else if ( row < 1 ) {
        [YBLog warn:@"Cannot track content highlight since row is invalid"];
    } else if ( contentId.length == 0 ){
        [YBLog warn:@"Cannot track content click since no contentId has been supplied."];
    } else {

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

        if ( dimensions != nil ){
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

        [YBLog notice: @"CONTENT HIGHLIGHT"];

        [self fireEvent: @"CONTENT HIGHLIGHT"
     dimensionsInternal: @{
                               @"eventType": @"ContentHighlight",
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
  * @paramsection The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  */

- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId{
    [self trackContentClick:section sectionOrder:sectionOrder column:column row:row contentId:contentId dimensions:nil metrics:nil];
}

/**
  * Tracks the location of user clicks.
  * @paramsection The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
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
  * @paramsection The section title. It is commonly used to indicate the section title presented over a grid layout (e.g. Recommended Movies, Continue Watching, etc).
  * @param column Used to indicate the column number where content is placed in a grid layout The first column is number 1.
  * @param row Used to indicate the row number where content is placed in a grid layout. The first row is number 1. In the case of a horizontal list instead of a grid, the row parameter should be set to 1.
  * @param contentId The unique content identifier of the content linked.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track content click since Product Analytics is uninitialized."];
    } else if ( section.length == 0 ){
        [YBLog warn:@"Cannot track content click since no section has been supplied."];
    } else if ( sectionOrder < 1 ){
        [YBLog warn:@"Cannot track content click since no sectionOrder is invalid."];
    } else if ( column < 1 ) {
        [YBLog warn:@"Cannot track content click since column is invalid."];
    } else if ( row < 1 ) {
        [YBLog warn:@"Cannot track content click since row is invalid."];
    } else if ( contentId.length == 0 ){
        [YBLog warn:@"Cannot track content click since no contentId has been supplied."];
    } else {

        [YBLog notice: @"CONTENT CLICK"];

        [self fireEvent: @"CONTENT CLICK"
     dimensionsInternal: @{
                               @"eventType": @"ContentClick",
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

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track play since Product Analytics is uninitialized."];
    } else if ( contentId.length == 0 ){
        [YBLog warn:@"Cannot track play since no contentId has been supplied."];
    } else {

        [YBLog notice: @"[PLAYER] Play"];

        [self fireAdapterEvent: @"[PLAYER] Play"
            dimensionsInternal: @{
                                   @"eventType": @"ContentPlayback",
                                   @"contentId": contentId
                                 }
                dimensionsUser: dimensions
                       metrics: metrics];
        
        if ( self._userState != nil ){
            [self._userState setActive: @"Play" playerStarted: false];
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
    
    if ( !self._initialized ){
        [YBLog warn:@"Cannot track player interaction since Product Analytics is uninitialized."];
    } else {
        [self trackPlayerInteraction: eventName
                          dimensions: dimensions
                             metrics: metrics
                       playerStarted: false];
    }
}

/**
  * Tracks content watching events.
  * @param eventName The name of the interaction (i.e., Pause, Seek, Skip Intro, Skip Ads, Switch Language, etc.).
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  * @param playerStarted Internal param informing that current interaction is responsible of first player start
  */

- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics playerStarted: (Boolean) playerStarted{

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track player interaction since Product Analytics is uninitialized."];
    } else if ( eventName.length == 0 ){
        [YBLog warn:@"Cannot track player interaction since no interaction name has been supplied."];
    } else {
        [YBLog notice: @"[PLAYER] %@", eventName];

        [self fireAdapterEvent: [@"[PLAYER] " stringByAppendingString:eventName]
            dimensionsInternal: @{
                                   @"eventType": @"ContentPlayback"
                                 }
                dimensionsUser: dimensions
                       metrics: metrics];
        
        if ( self._userState != nil ){
            [self._userState setActive: eventName playerStarted: playerStarted];
        }
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

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track search query since Product Analytics is uninitialized."];
    } else if ( searchQuery.length == 0 ){
        [YBLog warn:@"Cannot track search query since no searchQuery has been supplied."];
    } else {

        [YBLog notice: @"[SEARCH] Query %@", searchQuery];
        
        self._searchQuery = searchQuery;

        [self fireEvent: @"[SEARCH] Query"
     dimensionsInternal: @{
                            @"eventType": @"ContentSearch",
                            @"query":     self._searchQuery
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

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track search result since Product Analytics is uninitialized."];
    } else if ( resultCount < 0 ){
        [YBLog warn:@"Cannot track search result since resultCount is invalid."];
    } else {

        NSString * query = ( searchQuery != nil && searchQuery.length > 0 ? searchQuery : self._searchQuery );

        [YBLog notice: @"[SEARCH] Results %ld", resultCount];

        [self fireEvent: @"[SEARCH] Results"
     dimensionsInternal: @{
                            @"eventType":    @"ContentSearch",
                            @"query":        query,
                            @"resultCount":  [NSString stringWithFormat:@"%ld", resultCount]
                          }
         dimensionsUser: dimensions
                metrics: metrics];

    }
}

/**
  * Tracks user interactions with search results.
  * @param column The content placement column. It is commonly used to indicate the column number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param row The content placement row. It is commonly used to indicate the row number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param contentId The content identifier. It is used for internal content unequivocally identification (i.e., AAA000111222).
  * @param searchQuery The search term entered by the user.
  */

- (void) trackSearchClick: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (NSString *) searchQuery{
    [self trackSearchClick:column row:row contentId:contentId searchQuery:searchQuery dimensions:nil metrics:nil];
}

/**
  * Tracks user interactions with search results.
  * @param column The content placement column. It is commonly used to indicate the column number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param row The content placement row. It is commonly used to indicate the row number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param contentId The content identifier. It is used for internal content unequivocally identification (i.e., AAA000111222).
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  */

- (void) trackSearchClick: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions{
    [self trackSearchClick:column row:row contentId:contentId searchQuery:searchQuery dimensions:dimensions metrics:nil];
}

/**
  * Tracks user interactions with search results.
  * @param column The content placement column. It is commonly used to indicate the column number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param row The content placement row. It is commonly used to indicate the row number where content is placed in a grid layout (i.e.1, 2, etc..).
  * @param contentId The content identifier. It is used for internal content unequivocally identification (i.e., AAA000111222).
  * @param searchQuery The search term entered by the user.
  * @param dimensions Dimensions to track
  * @param metrics Metrics to track
  */

- (void) trackSearchClick: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track search click since Product Analytics is uninitialized."];
    } else if ( column < 1 ) {
        [YBLog warn:@"Cannot track search click since column is invalid."];
    } else if ( row < 1 ) {
        [YBLog warn:@"Cannot track search click since row is invalid."];
    } else if ( contentId.length == 0 ){
        [YBLog warn:@"Cannot track search click since no contentId has been supplied."];
    } else {
        NSString * query;
        
        query = ( searchQuery != nil && searchQuery.length > 0 ? searchQuery : self._searchQuery );

        [YBLog notice:@"[SEARCH] Result Click"];

        [self fireEvent: @"[SEARCH] Result Click"
     dimensionsInternal: @{
                            @"eventType": @"ContentSearch",
                            @"query":     query,
                            @"column":    [NSString stringWithFormat:@"%ld", column],
                            @"row":       [NSString stringWithFormat:@"%ld", row],
                            @"contentId": contentId
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

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track external application launch since Product Analytics is uninitialized."];
    } else if ( appName.length == 0 ){
        [YBLog warn:@"Cannot track external application launch since no appName has been supplied."];
    } else {

        [YBLog notice: @"APP LAUNCH %@", appName];

        [self fireEvent: @"APP LAUNCH"
     dimensionsInternal: @{
                            @"eventType": @"ExternalApplications",
                            @"appName":   appName
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

    if ( !self._initialized ){
        [YBLog warn:@"Cannot track external application exit since Product Analytics is uninitialized."];
    } else if ( appName.length == 0 ){
        [YBLog warn:@"Cannot track external application exit since no appName has been supplied."];
    } else {

        [YBLog notice: @"APP EXIT %@", appName];

        [self fireEvent: @"APP EXIT"
     dimensionsInternal: @{
                            @"eventType": @"ExternalApplications",
                            @"appName":   appName
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
    
    if ( !self._initialized ){
        [YBLog warn:@"Cannot track engagement event since Product Analytics is uninitialized."];
    } else if ( eventName.length == 0 ){
        [YBLog warn:@"Cannot track engagement event since no eventName has been supplied."];
    } else if ( contentId.length == 0 ){
        [YBLog warn:@"Cannot track engagement event since no contentId has been supplied."];
    } else {

        [YBLog notice:eventName];

        [self fireEvent: eventName
     dimensionsInternal: @{
                            @"eventType": @"Engagement",
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

    if ( !self._initialized ){
        [YBLog warn:@"Event cannot be tracked since Product Analytics is uninitialized."];
    } else if ( eventName.length == 0 ){
        [YBLog warn:@"Event cannot be tracked since no eventName has been supplied."];
    } else {

        [YBLog notice:eventName];

        [self fireEvent: eventName
     dimensionsInternal: @{
                            @"eventType": @"CustomEvent"
                          }
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

- (Boolean) fireEvent: (nonnull NSString *) eventName dimensionsInternal: (nullable NSDictionary<NSString *, NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *, NSString *> *) dimensionsUser metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics{
    
    NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> * dimensions;
    Boolean fired = false;

    dimensions = [self buildDimensions: dimensionsInternal
                        dimensionsUser: dimensionsUser];
    
    if ( self._infinity ){

        [self._infinity fireEvent: eventName
                       dimensions: dimensions[@"custom"]
                           values: metrics
               topLevelDimensions: dimensions[@"top"]];

        fired = true;

    } else {
        [YBLog warn:@"Cannot fire %@ since infinity is unavailable.", eventName];
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
    Boolean fired = false;
    
    if ( self._adapter ){

        dimensions = [self buildDimensions: dimensionsInternal
                            dimensionsUser: dimensionsUser];

        [self._adapter fireEventWithName: eventName
                              dimensions: dimensions[@"custom"]
                                  values: metrics
                      topLevelDimensions: dimensions[@"top"]];

        fired = true;
    } else {
        [YBLog warn:@"Cannot fire %@ since adapter is unavailable.", eventName];
    }

    return fired;
}

/**
  * Builds a list of top level and custom dimensions
  * @param dimensionsInternal Object containing list of internal dimensions
  * @param dimensionsUser Object containing list of custom dimensions
  * @private
  */

- (NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> *)buildDimensions:(nullable NSDictionary<NSString *,NSString *> *) dimensionsInternal dimensionsUser: (nullable NSDictionary<NSString *,NSString *> *) dimensionsUser{
    
    NSMutableDictionary <NSString *, NSString *> * dimensionsTopLevel;
    NSMutableDictionary <NSString *, NSString *> * dimensionsCustom;
    NSArray * topKeysDelete;
    NSArray * topKeys;
    
    dimensionsCustom = [NSMutableDictionary dictionary];
    dimensionsCustom[@"page"] = self._screenName;
    
    if ( dimensionsInternal != nil ){
        [dimensionsCustom addEntriesFromDictionary: dimensionsInternal];
    }

    if ( dimensionsUser != nil ){
        [dimensionsCustom addEntriesFromDictionary: dimensionsUser];
    }

    dimensionsCustom[@"eventSource"] = @"Product Analytics";
    
    // List of Top Level Dimensions
    
    topKeys = @[@"contentid", @"contentId", @"contentID", @"utmSource", @"utmMedium", @"utmCampaign", @"utmTerm", @"utmContent", @"profileId", @"profile_id"];
    topKeysDelete = @[@"contentid", @"contentId", @"contentID", @"profileId", @"profile_id"];

    // Create object with top level dimensions
    
    dimensionsTopLevel = [NSMutableDictionary dictionary];
    
    for (NSString * key in dimensionsCustom){
        if ( [topKeys containsObject: key] ){
            dimensionsTopLevel[key] = dimensionsCustom[key];
        }
    }
    
    // Remove top level dimensions from custom dimensions list
    
    for (NSString * key in topKeysDelete){
        [dimensionsCustom removeObjectForKey: key];
    }
    
    return @{@"custom": dimensionsCustom, @"top": dimensionsTopLevel};
}

@end
