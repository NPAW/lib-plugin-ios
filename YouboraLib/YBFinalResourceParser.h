//
//  YBFinalResourceParser.h
//  YouboraLib
//
//  Created by Tiago Pereira on 17/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ParseCompletion)(NSString * _Nonnull finalResource);
typedef void (^ParseFailure)(NSError * _Nonnull error);
typedef void (^Success)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id>* _Nonnull listenerParams);
typedef void (^Failure)(NSError * _Nonnull error);

@interface YBFinalResourceParser : NSObject

@property NSString * _Nullable resource;

-(Boolean)isSatisfied:(NSString*_Nonnull)resource;

-(void)parseResource:(NSString*_Nonnull)resource completion:(ParseCompletion _Nonnull )completion failure:(ParseFailure _Nonnull )failure;

- (void)createRequestWithHost:(NSString *_Nonnull)host service:(NSString *_Nullable)service success:(Success _Nonnull )success failure:(Failure _Nonnull )failure;
@end
