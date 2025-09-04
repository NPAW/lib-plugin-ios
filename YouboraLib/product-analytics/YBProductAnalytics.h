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
- (void) initialize: (NSString * _Nonnull) screenName productAnalyticsSettings: (YBProductAnalyticsSettings * _Nonnull) productAnalyticsSettings sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;
- (void) setInfinity: (YBInfinity * _Nonnull) infinity;
- (void) destroy;

- (void) adapterAfterSet: (YBPlayerAdapter * _Nullable) adapter;
- (void) adapterBeforeRemove;

- (Boolean) newSession;
- (Boolean) newSession: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;
- (Boolean) endSession;
- (Boolean) endSession: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;

- (void) loginSuccessful: (nonnull NSString *) userId;
- (void) loginSuccessful: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) loginSuccessful: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;
- (void) loginSuccessful: (nonnull NSString *) userId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;

- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId;
- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType;
- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;
- (void) loginSuccessful: (nonnull NSString *) userId profileId: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;

- (void) loginUnsuccessful;
- (void) loginUnsuccessful: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) loginUnsuccessful: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) logout;
- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;
- (void) logout: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;

- (void) userProfileCreated: (nonnull NSString *) profileId;
- (void) userProfileCreated: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType;
- (void) userProfileCreated: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) userProfileCreated: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) userProfileSelected: (nonnull NSString *) profileId;
- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType;
- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;
- (void) userProfileSelected: (nonnull NSString *) profileId profileType: (nullable NSString *) profileType dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics sessionDimensions: (nullable NSDictionary<NSString *, NSString *> *) sessionDimensions;

- (void) userProfileDeleted: (nonnull NSString *) profileId;
- (void) userProfileDeleted: (nonnull NSString *) profileId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) userProfileDeleted: (nonnull NSString *) profileId dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackNavByName: (nonnull NSString *) screenName;
- (void) trackNavByName: (nonnull NSString *) screenName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackNavByName: (nonnull NSString *) screenName dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent;
- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackAttribution: (nonnull NSString *) utmSource utmMedium: (nullable NSString *) utmMedium utmCampaign: (nullable NSString *) utmCampaign utmTerm: (nullable NSString *) utmTerm utmContent: (nullable NSString *) utmContent dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSectionVisible: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder;
- (void) trackSectionVisible: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSectionVisible: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

- (void) trackSectionHidden: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder;
- (void) trackSectionHidden: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions;
- (void) trackSectionHidden: (nonnull NSString *) section sectionOrder: (NSInteger) sectionOrder dimensions: (nullable NSDictionary<NSString *, NSString *> *) dimensions metrics: (nullable NSDictionary<NSString *, NSNumber *> *) metrics;

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
