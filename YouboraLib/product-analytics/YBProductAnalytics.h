//
//  YBProductAnalytics.h
//  YouboraLib
//
//  Created by Francisco Expósito on 06/02/2024.
//  Copyright © 2024 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBProductAnalyticsSettings.h"
#import "YBProductAnalyticsUserState.h"
#import "YouboraLib/YBOptions.h"
#import "YouboraLib/YBInfinity.h"
#import "YouboraLib/YBPlayerAdapter.h"

@interface YBProductAnalytics : NSObject

@property(nonatomic, weak) YBOptions * _Nullable _options;
@property(nonatomic, weak) YBInfinity * _Nullable _infinity;
@property(nonatomic, weak) YBPlayerAdapter * _Nullable _adapter;

@property(nonatomic, strong) YBProductAnalyticsSettings * _Nonnull _productAnalyticsSettings;
@property(nonatomic, strong) NSString * _Nonnull _screenName;
@property(nonatomic, strong) YBProductAnalyticsUserState * _Nullable _userState;
@property(nonatomic, strong) NSString * _Nullable _searchQuery;
@property(nonatomic, strong) NSTimer * _Nullable _contentHighlightTimeout;
@property(nonatomic, assign) Boolean _initialized;

- (id _Nonnull )init: (YBOptions * _Nonnull) options infinity: (YBInfinity * _Nonnull) infinity;
- (void) initialize: (NSString * _Nonnull) screenName productAnalyticsSettings: (YBProductAnalyticsSettings * _Nonnull) productAnalyticsSettings;
- (void) setInfinity: (YBInfinity * _Nonnull) infinity;
- (void) destroy;

- (void) adapterAfterSet: (YBPlayerAdapter * _Nullable) adapter;
- (void) adapterBeforeRemove;

- (Boolean) newSession;
- (Boolean) endSession;

- (void) loginSuccessful: (nonnull NSString *) username;
- (void) loginSuccessful: (nonnull NSString *) username dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) loginSuccessful: (nonnull NSString *) username dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) loginSuccessful: (nonnull NSString *) username profileId: (nonnull NSString *) profileId;
- (void) loginSuccessful: (nonnull NSString *) username profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType;
- (void) loginSuccessful: (nonnull NSString *) username profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) loginSuccessful: (nonnull NSString *) username profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) loginError;
- (void) loginError: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) loginError: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) logout;
- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metric;

- (void) userProfileCreate: (nonnull NSString *) profileId;
- (void) userProfileCreate: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType;
- (void) userProfileCreate: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) userProfileCreate: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) userProfileSelect: (nonnull NSString *) profileId;
- (void) userProfileSelect: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType;
- (void) userProfileSelect: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) userProfileSelect: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) userProfileDelete: (nonnull NSString *) profileId;
- (void) userProfileDelete: (nonnull NSString *) profileId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) userProfileDelete: (nonnull NSString *) profileId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackNavByName: (nonnull NSString *) screenName;
- (void) trackNavByName: (nonnull NSString *) screenName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackNavByName: (nonnull NSString *) screenName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent;
- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSectionIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder;
- (void) trackSectionIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSectionIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSectionOut: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder;
- (void) trackSectionOut: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSectionOut: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId;
- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) contentFocusIn: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) contentFocusOut;

- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId;
- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackContentClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackPlay: (nonnull NSString *) contentId;
- (void) trackPlay: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackPlay: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackPlayerInteraction: (nonnull NSString *) eventName;
- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackPlayerInteraction: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSearchQuery: (nonnull NSString *) query;
- (void) trackSearchQuery: (nonnull NSString *) query dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSearchQuery: (nonnull NSString *) query dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSearchResult: (NSInteger) resultCount searchQuery: (nullable NSString *) searchQuery;
- (void) trackSearchResult: (NSInteger) resultCount searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSearchResult: (NSInteger) resultCount searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSearchClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (nullable NSString *) searchQuery;
- (void) trackSearchClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSearchClick: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder column: (NSInteger) column row: (NSInteger) row contentId: (nonnull NSString *) contentId searchQuery: (nullable NSString *) searchQuery dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackExternalAppLaunch: (nonnull NSString *) appName;
- (void) trackExternalAppLaunch: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackExternalAppLaunch: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackExternalAppExit: (nonnull NSString *) appName;
- (void) trackExternalAppExit: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackExternalAppExit: (nonnull NSString *) appName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackEngagementEvent: (nonnull NSString *) eventName contentId: (nonnull NSString *) contentId;
- (void) trackEngagementEvent: (nonnull NSString *) eventName contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackEngagementEvent: (nonnull NSString *) eventName contentId: (nonnull NSString *) contentId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackEvent: (nonnull NSString *) eventName;
- (void) trackEvent: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackEvent: (nonnull NSString *) eventName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

@end
