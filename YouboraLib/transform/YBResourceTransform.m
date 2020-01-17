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
#import "YBHlsParser.h"
#import "YBCdnConfig.h"
#import "YBLocationHeaderParser.h"
#import "YBLog.h"
#import "YBDashParser.h"
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBResourceTransform()

// Private properties
@property(nonatomic, weak) YBPlugin * plugin;
@property(nonatomic, strong) NSString * realResource;
@property(nonatomic, strong) NSString * beginResource; // Initial resource
@property(nonatomic, strong) NSString * cdnName;
@property(nonatomic, strong) NSString * cdnNodeHost;
@property(nonatomic, assign) YBCdnType cdnNodeType;
@property(nonatomic, strong) NSString * cdnNodeTypeString;
@property(nonatomic, strong) NSString * cdnNameHeader;

@property(nonatomic, strong) YBHlsParser * hlsParser;
@property(nonatomic, strong) YBDashParser * dashParser;
@property(nonatomic, strong) YBCdnParser * cdnParser;
@property(nonatomic, strong) YBLocationHeaderParser * locHeaderParser;

@property(nonatomic, strong) NSMutableArray<NSString *> * cdnList;

@property(nonatomic, assign) bool hlsEnabled;
@property(nonatomic, assign) bool dashEnabled;
@property(nonatomic, assign) bool cdnEnabled;
@property(nonatomic, assign) bool locationHeaderParserEnabled;

@property(nonatomic, strong) NSTimer * timerTimeout;

@property(nonatomic, assign, readwrite) bool isFinished;

@end

@implementation YBResourceTransform

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.plugin = nil;
        self.isFinished = false;
    }
    return self;
}

- (instancetype)initWithPlugin:(YBPlugin *)plugin {
    self = [self init];
    
    self.plugin = plugin;
    self.realResource = nil;
    self.beginResource = nil;
    self.cdnName = nil;
    self.cdnNodeHost = nil;
    self.cdnNodeType = YBCdnTypeUnknown;
    self.cdnNodeTypeString = nil;
    
    self.isBusy = false;
    
    return self;
}

#pragma mark - Public methods
- (NSString *) getResource {
    if (self.realResource != nil) {
        return self.realResource;
    } else {
        return self.beginResource;
    }
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
        
        self.dashEnabled = [self.plugin isParseDASH];
        self.hlsEnabled = [self.plugin isParseHls];
        self.cdnEnabled = [self.plugin isParseCdnNode];
        self.locationHeaderParserEnabled = [self.plugin isParseLocationHeader];
        self.cdnList = [[self.plugin getParseCdnNodeList] mutableCopy];
        self.cdnNameHeader = [self.plugin getParseCdnNameHeader];
        
        if (self.cdnNameHeader != nil) {
            [YBCdnParser setBalancerHeaderName:self.cdnNameHeader];
        }
        
        self.beginResource = originalResource;
        
        [self setTimeout];
        
        if (self.locationHeaderParserEnabled) {
            [self parseLocationHeader];
        } else if (self.hlsEnabled) {
             [self parseHls];
        } else if (self.dashEnabled) {
             [self parseDash];
        } else if (self.cdnEnabled) {
            [self parseCdn];
        } else {
            [self done];
        }
    }
}


// Override
- (void)parse:(YBRequest *)request {
    if ([ConstantsYouboraService.start isEqualToString:request.service]) {
        NSMutableDictionary * lastSent = self.plugin.requestBuilder.lastSent;

        //No need to replace now
        /*NSString * resource = [self getResource];


        [request setParam:resource forKey:@"mediaResource"];
        lastSent[@"mediaResource"] = resource;*/

        if (self.cdnEnabled) {
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
- (void) parseHls {
    self.hlsParser = [self createHlsParser];
    
    [self.hlsParser addHlsTransformDoneDelegate:self];
    
    if (self.locHeaderParser) {
        [self.hlsParser parse:self.realResource parentResource:nil];
    } else {
        [self.hlsParser parse:self.beginResource parentResource:nil];
    }
    
}

- (void) parseDash {
    self.dashParser = [YBDashParser new];
    
    [self.dashParser addDashTransformDoneDelegate:self];
    
    if (self.locationHeaderParserEnabled) {
        [self.dashParser parse: self.realResource];
    } else {
        [self.dashParser parse: self.beginResource];
    }
}

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

- (void) parseLocationHeader {
    self.locHeaderParser = [self createLocHeaderParser];
    
    [self.locHeaderParser addLocationHeaderTransformDoneDelegate:self];
    
    [self.locHeaderParser parse:self.beginResource];
}

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

- (YBLocationHeaderParser *) createLocHeaderParser {
    return [YBLocationHeaderParser new];
}

# pragma mark - HlsTransformDoneDelegate
- (void) hlsTransformDone:(nullable NSString *) parsedResource fromHlsParser:(YBHlsParser *) parser {
    self.realResource = parsedResource;
    if (self.cdnEnabled) {
        [self parseCdn];
    } else {
        [self done];
    }
    self.hlsParser = nil;
}

# pragma mark - DashTransformDoneDelegate
- (void) dashTransformDone:(nullable NSString *) parsedResource fromDashParser:(YBDashParser*) parser {
    self.realResource = parsedResource;
    if (self.cdnEnabled) {
        [self parseCdn];
    } else {
        [self done];
    }
    self.dashParser = nil;
}

#pragma mark - CdnTransformDoneDelegate
- (void) cdnTransformDone:(YBCdnParser *) cdnParser {
    self.cdnName = cdnParser.cdnName;
    self.cdnNodeHost = cdnParser.cdnNodeHost;
    self.cdnNodeType = cdnParser.cdnNodeType;
    self.cdnNodeTypeString = cdnParser.cdnNodeTypeString;
    
    self.cdnParser = nil;
    
    if ([self getNodeHost] != nil) {
        [self done];
    } else {
        [self parseCdn];
    }
}

# pragma mark - LocationHeaderParserDoneTransformDoneDelegate
- (void)locationHeaderTransformDone:(nullable NSString *)parsedResource fromLocationHeaderParser:(nonnull YBLocationHeaderParser *)parser {
    self.realResource = [parser getResource];
}

@end
