//
//  YBTestableViewTransform.h
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBViewTransform.h"

@class YBRequest;

@interface YBTestableViewTransform : YBViewTransform

@property(nonatomic, strong) YBRequest * mockRequest;

- (YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service;

@end
