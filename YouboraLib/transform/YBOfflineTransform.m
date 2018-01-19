//
//  YBOfflineTransform.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBOfflineTransform.h"
#import "YBEventDataSource.h"
#import "YBRequest.h"
#import "YBConstants.h"
#import "YBYouboraUtils.h"
#import "YBLog.h"
#import "YBEvent.h"


@interface YBOfflineTransform()

@property(nonatomic, strong) YBEventDataSource * dataSource;

@end

@implementation YBOfflineTransform

- (instancetype) init{
    self = [super init];
    if (self) {
        self.sendRequest = false;
        self.isBusy = false;
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
    self.dataSource = [[YBEventDataSource alloc] init];
    
    //Skip if init
    if([service isEqualToString: [YouboraServiceInit substringFromIndex:1]]){
        return;
    }
    
    params[@"request"] = service;
    params[@"unixtime"] = [NSString stringWithFormat:@"%.0lf",[YBYouboraUtils unixTimeNow]];
    
    [self.dataSource lastIdWithCompletion:^(NSNumber* offlineId){
        __block int offlineIdInt = [offlineId intValue];
        [self.dataSource allEventsWithCompletion:^(NSArray * events) {
            int eventsCount = (int)[events count];
            if(eventsCount != 0 && [service isEqualToString:[YouboraServiceStart substringFromIndex:1]]){
                offlineIdInt++;
            }
            params[@"code"] = [NSString stringWithFormat:@"[VIEW_CODE]_%@",[NSString stringWithFormat:@"%d",offlineIdInt]];
            NSString* jsonEvents = [YBYouboraUtils stringifyDictionary:params];
            
            if(jsonEvents != nil){
                [YBLog debug:@"Saving offline event: %@",jsonEvents];
                
                YBEvent* event = [[YBEvent alloc] init];
                event.jsonEvents = jsonEvents;
                event.offlineId = [NSNumber numberWithInt:offlineIdInt];
                [self.dataSource putNewEvent:event completion:nil];
            }
            
        }];
    }];
}

@end
