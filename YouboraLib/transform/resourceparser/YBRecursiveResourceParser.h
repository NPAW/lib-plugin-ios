//
//  YBRecursiveResourceParser.h
//  YouboraLib
//
//  Created by Tiago Pereira on 25/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouboraLib/YouboraLib-Swift.h"

typedef void (^Completion) (NSString *finalResource);

@interface YBRecursiveResourceParser : NSObject

+(void)recursivelyParse:(NSString*)resource withParser:(id<YBResourceParser>)parser completion:(Completion)completion;

@end
