//
//  YBAppDatabaseSingleton.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBAppDatabaseSingleton.h"

@import Realm;

@interface YBAppDatabaseSingleton()

@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation YBAppDatabaseSingleton



#pragma mark - singleton method

+ (YBAppDatabaseSingleton*)sharedInstance
{
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    //static id sharedObject = nil;  //if you're not using ARC
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
        //sharedObject = [[[self alloc] init] retain]; // if you're not using ARC
    });
    return sharedObject;
}

- (RLMRealm*) getInstance{
    if(self.realm == nil){
        self.realm = [RLMRealm defaultRealm];
    }
    return self.realm;
}

@end
