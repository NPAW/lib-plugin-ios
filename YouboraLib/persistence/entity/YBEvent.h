//
//  YBEvent.h
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 11/01/2018.
//  Copyright © 2018 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Realm;

@interface YBEvent : RLMObject
    @property NSString* id;
    @property NSString* jsonEvents;
    @property NSDate* dateUpdate;
    @property NSNumber<RLMInt>* offlineId;
@end
