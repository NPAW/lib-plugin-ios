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

@interface YBResourceTransform() <CdnTransformDoneDelegate>

// Private properties
@property(nonatomic, strong) NSString * currentResource;

@property(nonatomic, strong) NSString * cdnName;
@property(nonatomic, strong) NSString * cdnNodeHost;
@property(nonatomic, assign) YBCdnType cdnNodeType;
@property(nonatomic, strong) NSString * cdnNodeTypeString;
@property(nonatomic, strong) NSString * cdnNameHeader;

@property(nonatomic, strong) YBCdnParser * cdnParser;

@property(nonatomic) Boolean cdnEnabled;

@property(nonatomic, strong) NSArray <id<YBResourceParser>> *parsers;

@property(nonatomic, strong) NSMutableArray<NSString *> * cdnList;

@property(nonatomic, strong) NSTimer * timerTimeout;
@property(nonatomic, weak) YBPlugin * plugin;

@property(nonatomic, assign, readwrite) bool isFinished;

@property(nonatomic, strong) NSString *transportFormat;

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

- (instancetype)initWithPlugin:(YBPlugin*)plugin {
    self = [self init];
    
    self.isBusy = false;
    
    self.plugin = plugin;
    
    if (self.plugin.isParseResource) {
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

- (void)begin:(NSString *)originalResource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat{
    if (!self.isBusy) {
        
        if ([YBResourceParserUtil isFinalURLWithResourceUrl:originalResource]) {
            self.currentResource = originalResource;
            [self done];
            return;
        }
        
        self.transportFormat = nil;
        self.isBusy = true;
        self.isFinished = false;
        
        self.cdnName = nil;
        self.cdnNodeHost = nil;
        self.cdnNodeType = YBCdnTypeUnknown;
        self.cdnNodeTypeString = nil;
        self.cdnEnabled = [self.plugin isParseCdnNode];
        self.cdnList = [[self.plugin getParseCdnNodeList] mutableCopy];
        
        if (self.cdnNameHeader != nil) {
            [YBCdnParser setBalancerHeaderName:self.cdnNameHeader];
        }
        
        [self setTimeout];
        
        if(self.parsers.count > 0) {
            [self parse:self.parsers.firstObject currentResource:originalResource userDefinedTransportFormat:definedTransportFormat];
        } else {
            [self parse:nil currentResource:originalResource userDefinedTransportFormat:definedTransportFormat];
        }
        
    }
}

-(void)parse:(id<YBResourceParser> _Nullable)parser currentResource:(NSString*)resource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat{
    //No more parsers available try to parse cdn then
    if (!parser) {
        self.currentResource = resource;
        [self parseCdn];
        return;
    }
    
    [self requestAndParse:parser currentResource:resource userDefinedTransportFormat:definedTransportFormat];
}

-(void)requestAndParse:(id<YBResourceParser> _Nullable)parser currentResource:(NSString*)resource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat{
    YBRequest *request = [[YBRequest alloc] initWithHost:resource andService:nil];
    
    [request addRequestSuccessListener:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable listenerParams) {
        if (![parser isSatisfiedWithResource:resource manifest:data]) {
            [self parse:[self getNextParser:parser] currentResource:resource userDefinedTransportFormat:definedTransportFormat];
        } else {
            NSString *newResource = [parser parseResourceWithData:data response:(NSHTTPURLResponse*)response listenerParents:listenerParams];
            
            if (!newResource && ![response.URL.absoluteString isEqualToString:resource]) {
                newResource = response.URL.absoluteString;
            }
            
            NSString *transportFormat = [parser parseTransportFormatWithData:data response:(NSHTTPURLResponse*)response listenerParents:listenerParams userDefinedTransportFormat: definedTransportFormat];
            
            if (transportFormat) {
                self.transportFormat = transportFormat;
            }
            
            if (!newResource) {
                [self parse:[self getNextParser:parser] currentResource:resource userDefinedTransportFormat:definedTransportFormat];
            } else {
                [self parse:parser currentResource:newResource userDefinedTransportFormat:definedTransportFormat];
            }
        }
    }];
    
    [request addRequestErrorListener:^(NSError * _Nullable error) {
        [self parse:[self getNextParser:parser] currentResource:resource userDefinedTransportFormat:definedTransportFormat];
    }];
    
    [request send];
}

-(id<YBResourceParser> _Nullable)getNextParser:(id<YBResourceParser>)parser {
    if (parser == self.parsers.lastObject) { return nil; }
    
    return [self.parsers objectAtIndex: [self.parsers indexOfObject:parser] + 1];
}


// Override
- (void)parse:(YBRequest *)request {
    if ([YBConstantsYouboraService.start isEqualToString:request.service]) {
        NSMutableDictionary * lastSent = self.plugin.requestBuilder.lastSent;
        
        //No need to replace now
        /*NSString * resource = [self getResource];
         
         
         [request setParam:resource forKey:YBConstantsRequest.mediaResource];
         lastSent[YBConstantsRequest.mediaResource] = resource;*/
        
        if (self.cdnEnabled) {
            NSString * cdn = request.params[YBConstantsRequest.cdn];
            if (cdn == nil) {
                cdn = [self getCdnName];
                [request setParam:cdn forKey:YBConstantsRequest.cdn];
            }
            
            lastSent[YBConstantsRequest.cdn] = cdn;
            
            [request setParam:[self getNodeHost] forKey:YBConstantsRequest.nodeHost];
            lastSent[YBConstantsRequest.nodeHost] = [self getNodeHost];
            
            [request setParam:[self getNodeType] forKey:YBConstantsRequest.nodeType];
            lastSent[YBConstantsRequest.nodeType] = [self getNodeType];
            
            [request setParam:[self getNodeTypeString] forKey:YBConstantsRequest.nodeTypeString];
            lastSent[YBConstantsRequest.nodeTypeString] = [self getNodeTypeString];
        }
    }
}

#pragma mark - Private methods

- (void) parseCdn {
    if (self.cdnList.count > 0 && self.cdnEnabled) {
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

- (void)cdnTransformDone:(nonnull YBCdnParser *)cdnParser {
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

- (void)done {
    if (self.isFinished) { return; }
    self.isFinished = true;
    
    [super done];
}

- (NSTimer *) createNonRepeatingScheduledTimerWithInterval:(NSTimeInterval) interval {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(parseTimeout:) userInfo:nil repeats:false];
}

- (YBCdnParser *) createCdnParser:(NSString *) cdn {
    return [YBCdnParser createWithName:cdn];
}

- (NSString *)getTransportFormat {
    return self.transportFormat;
}

@end
