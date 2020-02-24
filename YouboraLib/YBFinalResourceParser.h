//
//  YBFinalResourceParser.h
//  YouboraLib
//
//  Created by Tiago Pereira on 17/02/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *, id>* _Nonnull listenerParams);
typedef void (^Failure)(NSError * _Nonnull error);

@interface YBFinalResourceParser : NSObject

@property NSString * _Nullable resource;

-(Boolean)isSatisfied:(NSString*_Nonnull)resource;

- (void)createRequestWithHost:(NSString *_Nonnull)host service:(NSString *_Nullable)service success:(Success _Nonnull )success failure:(Failure _Nonnull )failure;

-(NSString* _Nullable)parseResourceWithData:(NSData* _Nullable)data response:(NSURLResponse* _Nullable)response listenerParams:(NSDictionary<NSString *, id>* _Nullable)listenerParams error:(NSError* _Nullable)error;

@end
