//
//  YBTestableRequest.m
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableRequest.h"

@implementation YBTestableRequest

- (NSMutableURLRequest *) createRequestWithUrl:(NSURL *) url {
    return self.mockRequest;
}

@end
