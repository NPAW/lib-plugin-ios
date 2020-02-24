//
//  YBTestableLocationHeaderParser.h
//  YouboraLib
//
//  Created by Tiago Pereira on 24/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBLocationHeaderParser.h"

typedef void (^Success)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id>* _Nonnull listenerParams);
typedef void (^Failure)(NSError * _Nonnull error);

@class YBRequest;

@interface YBTestableLocationHeaderParser : YBLocationHeaderParser

@property(nonatomic, strong) YBRequest * mockRequest;

@end
