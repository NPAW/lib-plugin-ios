//
//  YBResourceTransform.m
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBResourceTransform.h"

#import "YBPlugin.h"
#import "YBRequest.h"
#import "YBRequestBuilder.h"
#import "YBCdnParser.h"
#import "YBCdnConfig.h"
#import "YBLog.h"
#import "YouboraLib/YouboraLib-Swift.h"

typedef void (^ResourceCompletion)(NSString *finalResource);
typedef void (^RequestCompletion)(NSString *);

@interface YBResourceTransform()

// Private properties
@property(nonatomic, strong) NSString * currentResource;

@property(nonatomic, strong) NSString * cdnName;
@property(nonatomic, strong) NSString * cdnNodeHost;
@property(nonatomic, assign) YBCdnType cdnNodeType;
@property(nonatomic, strong) NSString * cdnNodeTypeString;
@property(nonatomic, strong) NSString * cdnNameHeader;

@property(nonatomic, strong) YBCdnParser * cdnParser;

@property(nonatomic, strong) NSArray <id<YBResourceParser>> *parsers;

@property(nonatomic, strong) NSMutableArray<NSString *> * cdnList;

@property(nonatomic, strong) NSTimer * timerTimeout;

@property(nonatomic, assign, readwrite) bool isFinished;

@end

@implementation YBResourceTransform

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFinished = false;
    }
    return self;
}

- (instancetype)initParsingResource:(Boolean)parseResource parsingCdn:(Boolean)parseCdn {
    self = [self init];
    
    self.cdnName = nil;
    self.cdnNodeHost = nil;
    self.cdnNodeType = YBCdnTypeUnknown;
    self.cdnNodeTypeString = nil;
    
    self.isBusy = false;
    
    if (parseResource) {
        self.parsers = @[
            [[YBLocationParser alloc] init],
            [[YBHlsParser alloc] init],
            [[YBDashParser alloc] init]
        ];
    } else {
        self.parsers = @[];
    }
    return self;
}

#pragma mark - Public methods
- (NSString *) getResource {
    return self.currentResource;
}

- (NSString *) getCdnName {
    return self.cdnName;
}

- (NSString *) getNodeHost {
    return self.cdnNodeHost;
}

- (NSString *) getNodeType {
    NSString * nodeType;
    switch (self.cdnNodeType) {
        case YBCdnTypeHit:
            nodeType = @"1";
            break;
        case YBCdnTypeMiss:
            nodeType = @"0";
            break;
        case YBCdnTypeUnknown:
        default:
            nodeType = nil;
            break;
    }
    return nodeType;
}

- (NSString *) getNodeTypeString {
    return self.cdnNodeTypeString;
}

- (void)begin:(NSString *)originalResource {
    if (!self.isBusy) {
        self.isBusy = true;
        self.isFinished = false;
        
        //        self.cdnList = [[self.plugin getParseCdnNodeList] mutableCopy];
        //        self.cdnNameHeader = [self.plugin getParseCdnNameHeader];
        
        //        if (self.cdnNameHeader != nil) {
        //            [YBCdnParser setBalancerHeaderName:self.cdnNameHeader];
        //        }
        
        [self setTimeout];
        
        if(self.parsers.count > 0) {
            [self parseResourceWithParser:self.parsers.firstObject withResource:originalResource andCompletion:^(NSString *finalResource) {
                self.currentResource = finalResource;
            }];
        } else {
            // do now cdn
        }
        
        
        
        
        //        for (id <YBFinalResourceParser> parser in self.parsers) {
        //            if ([parser isSatisfiedWithResource:self.currentResource]) {
        //                self.currentResource = [parser parseWithResource:self.currentResource];
        //            }
        //        }
        
        //        if (self.locationHeaderParserEnabled) {
        //            [self parseLocationHeader];
        //        } else if (self.hlsEnabled) {
        //             [self parseHls];
        //        } else if (self.dashEnabled) {
        //             [self parseDash];
        //        } else if (self.cdnEnabled) {
        //            [self parseCdn];
        //        } else {
        //            [self done];
        //        }
    }
}

-(void)parseResourceWithParser:(id<YBResourceParser>)parser withResource:(NSString*)resource andCompletion:(ResourceCompletion)completion {
    if (!parser) { completion(resource); }
    
//    if ([parser isSatisfiedWithResource:resource]) {
//        
//    } else {
//        [self parseResourceWithParser:[self getNextParser:parser] withResource:resource andCompletion:completion];
//    }
}


// Override
- (void)parse:(YBRequest *)request {
    if ([YBConstantsYouboraService.start isEqualToString:request.service]) {
        NSMutableDictionary * lastSent = nil; //self.plugin.requestBuilder.lastSent;
        
        //No need to replace now
        /*NSString * resource = [self getResource];
         
         
         [request setParam:resource forKey:@"mediaResource"];
         lastSent[@"mediaResource"] = resource;*/
        
        if (self.cdnParser) {
            NSString * cdn = request.params[@"cdn"];
            if (cdn == nil) {
                cdn = [self getCdnName];
                [request setParam:cdn forKey:@"cdn"];
            }
            
            lastSent[@"cdn"] = cdn;
            
            [request setParam:[self getNodeHost] forKey:@"nodeHost"];
            lastSent[@"nodeHost"] = [self getNodeHost];
            
            [request setParam:[self getNodeType] forKey:@"nodeType"];
            lastSent[@"nodeType"] = [self getNodeType];
            
            [request setParam:[self getNodeTypeString] forKey:@"nodeTypeString"];
            lastSent[@"nodeTypeString"] = [self getNodeTypeString];
        }
    }
}

#pragma mark - Private methods
//- (void) parseHls {
//    self.hlsParser = [self createHlsParser];
//
//    [self.hlsParser addHlsTransformDoneDelegate:self];
//
//    if (self.locHeaderParser) {
//        [self.hlsParser parse:self.realResource parentResource:nil];
//    } else {
//        [self.hlsParser parse:self.beginResource parentResource:nil];
//    }
//
//}
//
//- (void) parseDash {
//    self.dashParser = [YBDashParser new];
//
//    [self.dashParser addDashTransformDoneDelegate:self];
//
//    if (self.locationHeaderParserEnabled) {
//        [self.dashParser parse: self.realResource];
//    } else {
//        [self.dashParser parse: self.beginResource];
//    }
//}

- (void) parseCdn {
    if (self.cdnList.count != 0) {
        NSString * cdn = self.cdnList.firstObject;
        [self.cdnList removeObjectAtIndex:0];
        
        if ([self getNodeHost] != nil) {
            [self done];
            return;
        }
        
        self.cdnParser = [self createCdnParser:cdn];
        
        if (self.cdnParser == nil) {
            [self parseCdn];
        } else {
            [self.cdnParser addCdnTransformDelegate:self];
            
            // TODO: previous responses
            [self.cdnParser parseWithUrl:[self getResource] andPreviousResponses:nil];
        }
    } else {
        [self done];
    }
}

//- (void) parseLocationHeader {
//    self.locHeaderParser = [self createLocHeaderParser];
//
//    [self.locHeaderParser addLocationHeaderTransformDoneDelegate:self];
//
//    [self.locHeaderParser parse:self.currentResource];
//}

- (void) setTimeout {
    // Since an NSTimer is being scheduled here, ensure we are on the main thread
    if ([NSThread isMainThread]) {
        // Abort operation after 3 seconds
        self.timerTimeout = [self createNonRepeatingScheduledTimerWithInterval:3];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTimeout];
        });
    }
}

// Timer timeot selector
- (void) parseTimeout:(NSTimer *) timer {
    if (self.isBusy) {
        [self done];
        [YBLog warn:@"ResourceTransform has exceeded the maximum execution time (3s) and will be aborted"];
    }
}

- (void)done {
    self.isFinished = true;
    [super done];
}

- (NSTimer *) createNonRepeatingScheduledTimerWithInterval:(NSTimeInterval) interval {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(parseTimeout:) userInfo:nil repeats:false];
}

- (YBHlsParser *) createHlsParser {
    return [YBHlsParser new];
}

- (YBCdnParser *) createCdnParser:(NSString *) cdn {
    return [YBCdnParser createWithName:cdn];
}

@end
