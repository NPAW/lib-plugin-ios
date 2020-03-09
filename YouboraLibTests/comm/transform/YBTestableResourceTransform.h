//
//  YBTestableResourceTransform.h
//  YouboraLib
//
//  Created by Joan on 05/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBResourceTransform.h"

@protocol YBTestableResourceTransformProtocol

-(NSData* _Nullable)getDataForIteration:(NSInteger)iteration;
-(NSHTTPURLResponse* _Nullable)getResponseForIteration:(NSInteger)iteration;

@end

@interface YBTestableResourceTransform : YBResourceTransform

@property NSInteger iteration;

@property(nonatomic, strong) NSDictionary<NSString *, YBCdnParser *> * mockCdnParsers;
@property(nonatomic, strong) YBCdnParser * mockCdnParser;
@property(nonatomic, strong) NSString * lastCreatedCdnParser;
@property(nonatomic, strong) NSTimer * mockTimer;

@property(nonatomic, weak) id<YBTestableResourceTransformProtocol> delegate;

@end
