//
//  YBEvent.h
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBEvent : NSObject
    @property NSInteger id;
    @property NSString* jsonEvents;
    @property NSNumber* dateUpdate;
    @property NSNumber* offlineId;
@end
