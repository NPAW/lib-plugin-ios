//
//  YBTransform.m
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTransform.h"
#import "YBTransformSubclass.h"
#import "YBConstants.h"

@interface YBTransform()
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

-(void)addTranformDoneObserver:(id)observer andSelector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[self getNotificationName] object: nil];
}

-(void)removeTranformDoneObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:[self getNotificationName] object:nil];
}


#pragma mark - "Protected" methods
-(NSString*)getNotificationName {
    return NOTIFICATION_NAME_TRANSFORM_DONE;
}

- (void) done {
    self.isBusy = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:[self getNotificationName] object:self];
}

-(void)forceDone {
    [self done];
}

#pragma mark - Subclass methods
- (void)parse:(YBRequest *)request {
    
}

@end
