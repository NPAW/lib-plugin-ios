//
//  YBTransform.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTransform.h"
#import "YBTransformSubclass.h"

@interface YBTransform()

/// ---------------------------------
/// @name Private properties
/// ---------------------------------

/**
 * List of listeners that will be notified once the Transform is done, if it's asynchronous or
 * it has to wait for something to happen.
 */
@property (nonatomic, strong) NSMutableArray<id<YBTransformDoneListener>> * listeners;

@end

@implementation YBTransform

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listeners = [NSMutableArray arrayWithCapacity:1];
        self.isBusy = true;
        self.sendRequest = true;
    }
    return self;
}

#pragma mark - Public methods
- (void)addTransformDoneListener:(id<YBTransformDoneListener>)listener {
    if (listener != nil) {
        [self.listeners addObject:listener];
    }
}

- (void) removeTransformDoneListener:(id<YBTransformDoneListener>)listener {
    if (listener != nil) {
        [self.listeners removeObject:listener];
    }
}

- (bool)isBlocking:(nullable YBRequest *) request {
    return self.isBusy;
}

- (bool)hasToSend:(YBRequest *)request{
    return self.sendRequest;
}

- (YBTransformState) getState{
    if(!self.sendRequest){
        return YBStateOffline;
    }
    return self.isBusy ? YBStateBlocked : YBStateNoBlocked;
}

#pragma mark - "Protected" methods
- (void) done {
    self.isBusy = false;
    for (id<YBTransformDoneListener> listener in self.listeners) {
        [listener transformDone:self];
    }
}

#pragma mark - Subclass methods
- (void)parse:(YBRequest *)request {
    
}

@end
