//
//  YBEventDataSource.h
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBEvent;

@interface YBEventDataSource : NSObject

- (void) putNewEvent:(YBEvent*) event completion: (void (^)(void))querySuccessBlock;

- (void) allEventsWithCompletion: (void (^)(NSArray*))querySuccessBlock;

- (void) lastIdWithCompletion: (void (^)(NSNumber*))querySuccessBlock;

- (void) eventsWithOfflineId: (NSNumber*) offlineId completion: (void (^)(NSArray*))querySuccessBlock;

- (void) firstIdWithCompletion: (void (^)(NSNumber*))querySuccessBlock;

- (void) deleteEventsWithOfflineId: (NSNumber*) offlindeId completion: (void (^)(void))querySuccessBlock;

//- (void) deleteEventWithEventArray: (NSArray*) events completion: (void (^)(void))querySuccessBlock;

@end
