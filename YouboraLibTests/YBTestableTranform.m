//
//  YBTestableTranform.m
//  YouboraLib
//
//  Created by Tiago Pereira on 10/08/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import "YBTestableTranform.h"

@implementation YBTestableTranform

- (void)parse:(YBRequest *)request {
    [super parse:request];
    
    self.parseCalled = YES;
}

@end
