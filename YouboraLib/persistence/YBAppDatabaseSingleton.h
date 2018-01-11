//
//  YBAppDatabaseSingleton.h
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RLMRealm;

@interface YBAppDatabaseSingleton : NSObject

+ (YBAppDatabaseSingleton*)sharedInstance;

- (RLMRealm*) getInstance;

@end
