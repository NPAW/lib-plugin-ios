//
//  YBDashParser.m
//  YouboraLib
//
//  Created by nice on 25/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import "YBDashParser.h"
#import "YBRequest.h"
#import "YBDashFinalResourceParser.h"

#define LOCATION @"Location"
#define BASE_URL @"BaseURL"
#define SEGMENT_URL @"SegmentURL"
#define SEGMENT_TEMPLATE @"SegmentTemplate"
#define MEDIA_KEY @"media"

#define ATTRS_KEY @"attributes"
#define VALUE_KEY @"textValue"



@interface YBDashParser ()

@property (nonatomic, strong) NSString* realResource;
@property (nonatomic, strong) NSString* location;

@property (nonatomic, strong) YBDashFinalResourceParser *locationParser;
@property (nonatomic, strong) NSArray <YBDashFinalResourceParser*> *mediaParsers;

@property(nonatomic, strong) NSMutableArray<id<DashTransformDoneDelegate>> * delegates;

@end

@implementation YBDashParser

-(instancetype)init {
    self = [super init];
    
    if (self) {
        self.realResource = nil;
        self.location = nil;
        self.delegates = [[NSMutableArray alloc] init];
        self.locationParser = [[YBDashFinalResourceParser alloc] initWithRegex:@"<Location>\n{0,1}(.*)\n{0,1}</Location>"];
        self.mediaParsers = @[
            [[YBDashFinalResourceParser alloc] initWithRegex:@"<BaseURL>\n{0,1}(.*)\n{0,1}</BaseURL>"],
            [[YBDashFinalResourceParser alloc] initWithRegex:@"<SegmentTemplate.+media=\"(.+?)\".+"],
            [[YBDashFinalResourceParser alloc] initWithRegex:@"<SegmentURL.+media=\"(.+?)\".+"],
        ];
    }
    
    return self;
}

-(NSString *) getResource {
    return self.realResource;
}

-(NSString *) getLocation {
    return self.location;
}

-(void) addDashTransformDoneDelegate:(id<DashTransformDoneDelegate>) delegate {
    if (delegate != nil && ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

-(void) removeDashTransformDoneDelegate:(id<DashTransformDoneDelegate>) delegate {
    if (self.delegates != nil && delegate != nil) {
        [self.delegates removeObject:delegate];
    }
}

-(void)parse:(NSString*)resource {
    if (![[resource pathExtension] isEqualToString:@"mpd"]) {
        [self done];
        return;
    }
    
    YBRequest *request = [self createRequestWithHost:resource andService:nil];
    
    __weak __typeof(self) weakSelf = self;
    
    [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString*, id>* _Nullable listenerParams) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *) response;
        NSString *dashString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (httpResponse.statusCode == 200 && dashString) {
            strongSelf.location = [strongSelf getLocation:dashString];
            if (strongSelf.location) {
                [strongSelf parse:strongSelf.location];
                return;
            }
            
            strongSelf.realResource = [strongSelf getRealResource:dashString];
        }
        
        [strongSelf done];
    }];
    
    [request addRequestErrorListener:^(NSError * _Nullable error) {
        [weakSelf done];
    }];
    
    [request send];
}

-(void)done {
    if(self.delegates) {
        for (id<DashTransformDoneDelegate> delegate in self.delegates) {
            [delegate dashTransformDone:self.realResource fromDashParser:self];
        }
    }
}

-(NSString*)getLocation:(NSString*)dashXml {
    return [self.locationParser parseForDash:dashXml];
}

-(NSString*)getRealResource:(NSString*)dashXml {
    for (YBDashFinalResourceParser *parser in self.mediaParsers) {
        NSString *result = [parser parseForDash:dashXml];
        if (result) { return result; }
    }
    
    return nil;
}

-(YBRequest *) createRequestWithHost:(NSString *) host andService:(NSString *) service {
    return [[YBRequest alloc] initWithHost:host andService:service];
}


@end
