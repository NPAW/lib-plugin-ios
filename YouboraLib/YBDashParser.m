//
//  YBDashParser.m
//  YouboraLib
//
//  Created by nice on 11/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBDashParser.h"
#import "YBLog.h"
#import "YBRequest.h"

@interface YBDashParser()
@property(nonatomic, strong) NSString * realResource;
@property(nonatomic, strong) NSMutableArray<id<DashTransformDoneDelegate>>* delegates;
@end

@implementation YBDashParser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.realResource = nil;
        self.delegates = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)parse:(NSString *)resource {
    YBRequest * request = [self createRequestWithHost:resource andService:nil];
    request.method = YouboraHTTPMethodHead;
    request.maxRetries = 0;
}


- (void) addDashTransformDoneDelegate:(id<DashTransformDoneDelegate>) delegate {
    if (delegate && ![self.delegates containsObject:delegate]) { [self.delegates addObject:delegate];}
}

- (void) removeDashTransformDoneDelegate:(id<DashTransformDoneDelegate>) delegate {
    if (delegate) { [self.delegates removeObject:delegate]; }
}

- (NSString *) getResource {
    return self.realResource;
}


#pragma mark - Private methods
- (void) done {
    for (id<DashTransformDoneDelegate> delegate in self.delegates) {
        [delegate dashTransformDone:[self getResource] fromDashParser:self];
    }
}


@end
