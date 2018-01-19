//
//  YBEventQueries.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 16/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#ifndef YBEventQueries_h
#define YBEventQueries_h

#import <Foundation/Foundation.h>

@interface YBEventQueries : NSObject

FOUNDATION_EXPORT NSString * const YouboraEventCreateTable;

FOUNDATION_EXPORT NSString * const YouboraEventGetAll;

FOUNDATION_EXPORT NSString * const YouboraEventCreate;	

FOUNDATION_EXPORT NSString * const YouboraEventGetLastId;

FOUNDATION_EXPORT NSString * const YouboraEventGetByOfflineId;

FOUNDATION_EXPORT NSString * const YouboraEventGetFirstId;

FOUNDATION_EXPORT NSString * const YouboraEventDeleteEventsByOfflineId;

@end

#endif
