//
//  YBTestableViewTransform.m
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTestableViewTransform.h"

#import "YBRequest.h"

#import <OCMockito/OCMockito.h>
#import "YouboraLib/YouboraLib-Swift.h"

@implementation YBTestableViewTransform

- (YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service {
    if (self.mockRequest == nil) {
        self.mockRequest = mock([YBRequest class]);
    }
    return self.mockRequest;
}

- (NSString *) getViewCodeTimeStamp {
    self.viewCodeTimestamp = [NSString stringWithFormat:@"%lf",[YBYouboraUtils unixTimeNow]];
    return self.viewCodeTimestamp;
}

@end
