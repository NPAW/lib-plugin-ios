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
@property (nonatomic, weak) id<YBTransformDoneListener> listener;

@end

@implementation YBTransform

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isBusy = true;
        self.sendRequest = true;
    }
    return self;
}

#pragma mark - Public methods
- (void)addTransformDoneListener:(id<YBTransformDoneListener>)listener {
    if (listener != nil) {
        self.listener = listener;
    }
}

- (void) removeTransformDoneListener:(id<YBTransformDoneListener>)listener {
    if (listener == self.listener) {
        self.listener = nil;
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
    if (self.listener) {
        [self.listener transformDone:self];
    }
}

#pragma mark - Subclass methods
- (void)parse:(YBRequest *)request {
    
}

@end
