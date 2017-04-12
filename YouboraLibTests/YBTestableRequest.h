//
//  YBTestableRequest.h
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBRequest.h"

@interface YBTestableRequest : YBRequest

@property(nonatomic, strong) NSMutableURLRequest * mockRequest;

@end
