//
//  YBEventQueries.m
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 16/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import "YBEventQueries.h"

@implementation YBEventQueries

NSString * const YouboraEventCreateTable = @"CREATE TABLE `Event` (`uid` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `json_events` TEXT, `date_update` INTEGER, `offline_id` INTEGER NOT NULL);";
NSString * const YouboraEventCreate = @"INSERT INTO Event(json_events,date_update,offline_id) values (?,?,?)";
NSString * const YouboraEventGetAll = @"SELECT * FROM Event";
NSString * const YouboraEventGetLastId = @"Select offline_id from Event ORDER BY offline_id DESC LIMIT 1 ";
NSString * const YouboraEventGetByOfflineId = @"Select * from Event where offline_id = %@";
NSString * const YouboraEventGetFirstId = @"Select offline_id from Event ORDER BY offline_id ASC LIMIT 1";
NSString * const YouboraEventDeleteEventsByOfflineId = @"Delete from Event where offline_id = %@";

@end
