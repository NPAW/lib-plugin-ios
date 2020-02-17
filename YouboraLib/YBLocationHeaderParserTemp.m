//
//  YBLocationHeaderParser.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 13/03/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

//#import "YBLocationHeaderParser.h"
//#import "YBLog.h"
//#import "YBRequest.h"
//
//@interface YBLocationHeaderParser()
//
//@property(nonatomic, strong) NSString * realResource;
//@property(nonatomic, strong) NSMutableArray<id<LocationHeaderTransformDoneDelegate>> * delegates;
//
//@end
//
//@implementation YBLocationHeaderParser
//
//#pragma mark - Init
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.realResource = nil;
//        self.delegates = [NSMutableArray arrayWithCapacity:1];
//    }
//    return self;
//}
//
//- (void) parse:(NSString *) resource {
//    YBRequest * request = [self createRequestWithHost:resource andService:nil];
//    request.method = YouboraHTTPMethodHead;
//    request.maxRetries = 0;
//    
//    __weak typeof(self) weakSelf = self;
//    [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id>* listenerParams) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
//        NSDictionary * responseHeaders = httpResponse.allHeaderFields;
//        if (responseHeaders != nil && [responseHeaders count] != 0 && responseHeaders[@"Location"] != nil) {
//            strongSelf.realResource = responseHeaders[@"Location"];
//            [strongSelf done];
//        }
//    }];
//    
//    [request addRequestErrorListener:^(NSError * _Nullable error) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf done];
//    }];
//    
//    [request send];
//}
//
//- (void) addLocationHeaderTransformDoneDelegate:(id<LocationHeaderTransformDoneDelegate>) delegate {
//    if (delegate != nil && ![self.delegates containsObject:delegate]) {
//        [self.delegates addObject:delegate];
//    }
//}
//
//- (void) removeLocationHeaderTransformDoneDelegate:(id<LocationHeaderTransformDoneDelegate>) delegate {
//    if (self.delegates != nil && delegate != nil) {
//        [self.delegates removeObject:delegate];
//    }
//}
//
//- (NSString *) getResource {
//    return self.realResource;
//}
//
//#pragma mark - Private methods
//- (void) done {
//    for (id<LocationHeaderTransformDoneDelegate> delegate in self.delegates) {
//        [delegate locationHeaderTransformDone:[self getResource] fromLocationHeaderParser:self];
//    }
//}
//
//- (YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service {
//    return [[YBRequest alloc] initWithHost:host andService:service];
//}
//
//@end
