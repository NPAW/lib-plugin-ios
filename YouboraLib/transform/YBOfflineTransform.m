//
//  YBOfflineTransform.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBOfflineTransform.h"
#import "YBRequest.h"
#import "YBLog.h"
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBOfflineTransform()

@property(nonatomic, strong) YBEventDataSource * dataSource;
@property(nonatomic, assign) BOOL startSaved;
@property(nonatomic, strong) NSMutableArray * queuedEvents;
@end

@implementation YBOfflineTransform

- (instancetype) init{
    self = [super init];
    if (self) {
        self.sendRequest = false;
        self.isBusy = false;
        self.startSaved = false;
        self.queuedEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) parse:(nullable YBRequest *)request{
    if(request != nil && request.params != nil && request.params.count > 0){
        [self saveEventWithParams:request.params andService:[request.service substringFromIndex:1]];
    }
}

- (bool) hasToSend:(YBRequest *)request{
    return false;
}

- (YBTransformState) getState{
    return YBStateOffline;
}

- (void) saveEventWithParams:(NSMutableDictionary*) params andService:(NSString *) service{
    self.dataSource = [YBEventDataSource new];
    
    //Skip if init
    if([service isEqualToString: [YBConstantsYouboraService.sInit substringFromIndex:1]]){
        return;
    }
    
    params[@"request"] = service;
    params[@"unixtime"] = [NSString stringWithFormat:@"%.0lf",[YBYouboraUtils unixTimeNow]];
    
    if (self.startSaved || [service isEqualToString:[YBConstantsYouboraService.start substringFromIndex:1]]) {
        [self.dataSource lastIdWithCompletion:^(NSInteger offlineId){
            __block NSInteger offlineIdInt = offlineId;
            [self.dataSource allEventsWithCompletion:^(NSArray * events) {
                int eventsCount = (int)[events count];
                if(eventsCount != 0 && [service isEqualToString:[YBConstantsYouboraService.start substringFromIndex:1]]){
                    offlineIdInt++;
                }
                params[@"code"] = @"[VIEW_CODE]";
                NSString* jsonEvents = [YBYouboraUtils stringifyDictionary:params];
                
                if(jsonEvents != nil){
                    [YBLog debug:@"Saving offline event: %@",jsonEvents];
                    if ([service isEqualToString:[YBConstantsYouboraService.start substringFromIndex:1]]) {
                        [self.dataSource putNewEventWithOfflineId:offlineIdInt jsonEvents:jsonEvents completion:^{
                            self.startSaved = true;
                            [self processQueue];
                        }];
                    } else if ([service isEqualToString:[YBConstantsYouboraService.stop substringFromIndex:1]]) {
                        [self.dataSource putNewEventWithOfflineId:offlineIdInt jsonEvents:jsonEvents completion:^{
                                                   self.startSaved = false;
                        }];
                    } else {
                        [self.dataSource putNewEventWithOfflineId:offlineIdInt jsonEvents:jsonEvents completion:nil];
                    }
                    
                }
                
            }];
        }];
    } else{
        [self.queuedEvents addObject:params];
    }
}

- (void) processQueue {
    for (int k = 0; k < self.queuedEvents.count; k++) {
        [self saveEventWithParams:self.queuedEvents[k] andService:self.queuedEvents[k][@"request"]];
    }
}

@end
