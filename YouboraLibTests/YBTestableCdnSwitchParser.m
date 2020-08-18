//
//  YBTestableCdnSwitchParser.m
//  YouboraLib
//
//  Created by Tiago Pereira on 12/08/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBTestableCdnSwitchParser.h"
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import "YBRequest.h"

@implementation YBTestableCdnSwitchParser

-(YBRequest*)getRequest:(NSString*)resource {
    return self.mockRequest;
}

@end
