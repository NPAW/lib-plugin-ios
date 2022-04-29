//
//  YBCdnParserTest.m
//  YouboraLib
//
//  Created by Joan on 04/04/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "YBCdnParser.h"
#import "YBTestableCdnParser.h"
#import "YBParsableResponseHeader.h"
#import "YBRequest.h"

@interface YBCdnParserTest : XCTestCase<CdnTransformDoneDelegate>

@property(nonatomic, strong) NSString * customCdnCode;
@property(nonatomic, strong) NSString * customCdnName;
@property(nonatomic, copy) void (^transformDoneBlock) (YBCdnParser * cdnParser);

@end

@implementation YBCdnParserTest

- (void)setUp {
    [super setUp];
    
    self.customCdnCode = @"CSTM_CDN_CODE";
    self.customCdnName = @"CustomCdnName";
    
    // Create basic custom cdn definition
    YBCdnConfig * cdnConfig = [[YBCdnConfig alloc] initWithCode:self.customCdnCode];
    [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementTypeAndHost headerName:@"X-Header" andRegexPattern:@"(.+)\\sfrom\\s.+\\(.+\\/(.+)\\).*"]];
    cdnConfig.requestHeaders[@"header-name"] = @"header-value";
    cdnConfig.typeParser = ^YBCdnType(NSString * type) {
        if ([@"TCP_HAT" isEqualToString:type]) {
            return YBCdnTypeHit;
        }
        
        if ([@"TCP_MESS" isEqualToString:type]) {
            return YBCdnTypeMiss;
        }
        
        return YBCdnTypeUnknown;
    };
    
    [YBCdnParser addCdn:self.customCdnName withConfig:cdnConfig];
}

- (void)testDefaults {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameAkamai];
    
    XCTAssertNil(parser.cdnNodeTypeString);
    XCTAssertEqual(YBCdnTypeUnknown, parser.cdnNodeType);
    XCTAssertNil(parser.cdnNodeHost);
    XCTAssertNil(parser.cdnName);
}

- (void)testCdnResolution {
    
    static bool callbackInvoked = false;

    YBTestableCdnParser * parser = (YBTestableCdnParser *) [YBTestableCdnParser createWithName:self.customCdnName];
    
    self.transformDoneBlock = ^(YBCdnParser * cdnParser){
        callbackInvoked = true;
    };
    
    [parser addCdnTransformDelegate:self];
    
    [parser parseWithUrl:@"resourceurl" andPreviousResponses:nil];
    
    // Verify request fields are set
    [((YBRequest *) verifyCount(parser.mockRequest, times(1))) setMethod:YouboraHTTPMethodHead];
    [verifyCount(parser.mockRequest, times(1)) setRequestHeaders:[@{@"header-name":@"header-value"} mutableCopy]];
    [verifyCount(parser.mockRequest, times(1)) setMaxRetries:0];
    
    // Capture request callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(parser.mockRequest) addRequestSuccessListener:(id)captor];
    
    // Mock response
    NSHTTPURLResponse * mockResponse = mock([NSHTTPURLResponse class]);
    stubProperty(mockResponse, allHeaderFields, @{@"X-Header":@"TCP_HAT from a(a/HOST_VALUE)"});
    
    ((YBRequestSuccessBlock) captor.value)(mock([NSData class]), mockResponse, [[NSMutableDictionary alloc] init]);
    
    XCTAssertTrue(callbackInvoked);
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST_VALUE", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"TCP_HAT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(self.customCdnCode, parser.cdnName);
}

- (void)testRequestError {
    static bool callbackInvoked = false;

    YBTestableCdnParser * parser = (YBTestableCdnParser *) [YBTestableCdnParser createWithName:self.customCdnName];

    self.transformDoneBlock = ^(YBCdnParser * cdnParser){
        callbackInvoked = true;
    };
    
    [parser addCdnTransformDelegate:self];
    
    [parser parseWithUrl:@"resourceurl" andPreviousResponses:nil];
    
    // Capture request callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(parser.mockRequest) addRequestErrorListener:(id)captor];
    
    ((YBRequestErrorBlock) captor.value)(mock([NSError class]));
    
    // Callback called
    XCTAssertTrue(callbackInvoked);
    
    XCTAssertNil(parser.cdnNodeTypeString);
    XCTAssertEqual(YBCdnTypeUnknown, parser.cdnNodeType);
    XCTAssertNil(parser.cdnNodeHost);
    XCTAssertNil(parser.cdnName);
}

- (void)testListeners {
    YBTestableCdnParser * parser = (YBTestableCdnParser *) [YBTestableCdnParser createWithName:self.customCdnName];

    static int numberOfCallbacks = 0;
    
    self.transformDoneBlock = ^(YBCdnParser * cdnParser){
        numberOfCallbacks++;
    };
    
    [parser removeCdnTransformDelegate:self]; // should do nothing
    
    [parser parseWithUrl:@"resourceurl" andPreviousResponses:nil];
    
    // Capture request callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(parser.mockRequest) addRequestErrorListener:(id)captor];
    
    // Callback
    ((YBRequestErrorBlock) captor.value)(mock([NSError class]));
    
    XCTAssertEqual(0, numberOfCallbacks);
    
    [parser addCdnTransformDelegate:self];
    [parser addCdnTransformDelegate:self];
    
    // Callback
    ((YBRequestErrorBlock) captor.value)(mock([NSError class]));
    
    XCTAssertEqual(1, numberOfCallbacks);
    
    [parser removeCdnTransformDelegate:self];
    
    // Callback
    ((YBRequestErrorBlock) captor.value)(mock([NSError class]));
    
    XCTAssertEqual(1, numberOfCallbacks);
}

- (void)testTwoElementCdn {
    // Create custom cdn definition
    YBCdnConfig * cdnConfig = [[YBCdnConfig alloc] initWithCode:@"TWO_ELEMENT_CDN"];
    [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementType headerName:@"Header-type" andRegexPattern:@"(.+)"]];
    [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHost headerName:@"Header-host" andRegexPattern:@"(.+)"]];
    cdnConfig.typeParser = ^YBCdnType(NSString * _Nonnull type) {
        if ([@"HIT" isEqualToString:type]) {
            return YBCdnTypeHit;
        }
        
        if ([@"MISS" isEqualToString:type]) {
            return YBCdnTypeMiss;
        }
        
        return YBCdnTypeUnknown;
    };
    
    [YBCdnParser addCdn:@"TwoElementCdn" withConfig:cdnConfig];
    
    YBTestableCdnParser * parser = (YBTestableCdnParser *) [YBTestableCdnParser createWithName:@"TwoElementCdn"];

    [parser parseWithUrl:@"resource" andPreviousResponses:nil];
    
    // Capture request callback
    HCArgumentCaptor * captor = [HCArgumentCaptor new];
    [verify(parser.mockRequest) addRequestSuccessListener:(id)captor];
    
    // Mock response
    NSHTTPURLResponse * mockResponse = mock([NSHTTPURLResponse class]);
    stubProperty(mockResponse, allHeaderFields, (@{@"Header-type":@"MISS", @"Header-host":@"cdn_host_value"}));
    
    ((YBRequestSuccessBlock) captor.value)(mock([NSData class]), mockResponse, [[NSMutableDictionary alloc] init]);
    
    XCTAssertEqual(YBCdnTypeMiss, parser.cdnNodeType);
    XCTAssertEqualObjects(@"MISS", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"cdn_host_value", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"TWO_ELEMENT_CDN", parser.cdnName);
}

- (void)testInvalidCdnName {
    XCTAssertNil([YBCdnParser createWithName:@"NonExistentCdnName"]);
  
    // ignore "Null passed to a callee that requires a non-null argument" warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    
    XCTAssertNil([YBCdnParser createWithName:nil]);
    
#pragma clang diagnostic pop
}

- (void)testCdnResolutionWithResponse {
    // This cdn resolution should be done without creating a request
    // Since we will provide the needed responses from a "previous" request
    
    YBTestableCdnParser * parser = (YBTestableCdnParser *) [YBTestableCdnParser createWithName:self.customCdnName];
    
    NSDictionary * requestHeaders = @{@"header-name":@"header-value"};
    
    NSDictionary * responses = @{requestHeaders:@{@"X-Header":@"TCP_MESS from a(a/HOST_VALUE)"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeMiss, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST_VALUE", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"TCP_MESS", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(self.customCdnCode, parser.cdnName);
}

- (void)testCdnNameFromBalancer {
    [YBCdnParser setBalancerHeaderName:@"cdn-name" andNodeHeader:@""];
    
    NSString * cdnName = @"cdn-name-from-balancer";
    
    YBCdnParser * cdnParser = [YBCdnParser createWithName:YouboraCDNNameBalancer];
    
    NSDictionary * responses = @{@{}:@{@"cdn-name":cdnName}};
    
    [cdnParser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    XCTAssertEqualObjects(cdnName.uppercaseString, cdnParser.cdnName);
}

- (void)testCdnNameAndHostFromBalancer {
    [YBCdnParser setBalancerHeaderName:@"cdn-name" andNodeHeader:@"cdn-host"];
    
    NSString * cdnName = @"cdn-name-from-balancer";
    NSString * cdnNodeHost = @"cdn-host-from-balancer";

    YBCdnParser * cdnParser = [YBCdnParser createWithName:YouboraCDNNameBalancer];
    
    NSDictionary * responses = @{@{}:@{@"cdn-name":[NSString stringWithFormat:@"%@\n", cdnName],@"cdn-host":cdnNodeHost}};

    [cdnParser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    XCTAssertEqualObjects(cdnName.uppercaseString, cdnParser.cdnName);
    XCTAssertEqualObjects(cdnNodeHost, cdnParser.cdnNodeHost);
}

- (void)testHostAndType {
    // Create custom cdn definition
    YBCdnConfig * cdnConfig = [[YBCdnConfig alloc] initWithCode:@"HOST_AND_TYPE_CDN"];
    [cdnConfig.parsers addObject:[[YBParsableResponseHeader alloc] initWithElement:YBCdnHeaderElementHostAndType headerName:@"X-Header" andRegexPattern:@"(.+)\\/(.+)"]];
    cdnConfig.typeParser = ^YBCdnType(NSString * _Nonnull type) {
        if ([@"TCP_HAT" isEqualToString:type]) {
            return YBCdnTypeHit;
        }
        
        if ([@"TCP_MESS" isEqualToString:type]) {
            return YBCdnTypeMiss;
        }
        
        return YBCdnTypeUnknown;
    };
    
    [YBCdnParser addCdn:@"HostAndTypeCdn" withConfig:cdnConfig];
    
    YBTestableCdnParser * parser = (YBTestableCdnParser *) [YBTestableCdnParser createWithName:@"HostAndTypeCdn"];
    
    NSDictionary * responses = @{@{}:@{@"X-Header":@"HOST/TCP_HAT"}};

    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"TCP_HAT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"HOST_AND_TYPE_CDN", parser.cdnName);
}

// CDN-specific tests
- (void)testLevel3 {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameLevel3];
    
    NSDictionary * responses = @{@{@"X-WR-DIAG":@"host"}:@{@"X-WR-DIAG":@"Host:HOST123 Type:TCP_MEM_HIT"}};

    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST123", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"TCP_MEM_HIT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"LEVEL3", parser.cdnName);
}

- (void)testCloudfront {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameCloudfront];
    
    NSDictionary * responses = @{@{}:@{@"X-Amz-Cf-Id":@"HOST123", @"X-Cache":@"Hit a"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST123", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"Hit", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"CLOUDFRT", parser.cdnName);
}

- (void)testHighwinds {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameHighwinds];
    
    NSDictionary * responses = @{@{}:@{@"X-HW":@"a,0123.HOST123.c"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST123", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"c", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"HIGHNEGR", parser.cdnName);
}

- (void)testFastly {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameFastly];
    
    NSDictionary * responses = @{@{@"X-WR-DIAG":@"host"}:@{@"X-Served-By":@"HOST123",@"X-Cache":@"HIT"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST123", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"HIT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"FASTLY", parser.cdnName);
}

- (void)testAkamai {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameAkamai];
    
    NSDictionary * responses = @{@{@"Pragma":@"akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-get-request-id,akamai-x-get-nonces,akamai-x-get-client-ip,akamai-x-feo-trace"}:@{@"X-Cache":@"TCP_HIT from HOST123.deploy.akamaitechnologies.com (a/288) (D)"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"HOST123", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"TCP_HIT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"AKAMAI", parser.cdnName);
}

- (void)testAkamai2 {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameAkamai];
    
    NSDictionary * request = @{@"Pragma":@"akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-get-request-id,akamai-x-get-nonces,akamai-x-get-client-ip,akamai-x-feo-trace"};
        
    NSMutableDictionary * response = [[NSMutableDictionary alloc] init];
    response[@"Akamai-Mon-Iucid-Del"] = @"1182835";
    
    response[@"Akamai-Cache-Status"] = @"Miss from child, Miss from parent";

    NSDictionary * responses = @{request:response};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeMiss, parser.cdnNodeType);
    XCTAssertEqualObjects(@"1182835", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"Miss", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"AKAMAI", parser.cdnName);
}

- (void)testAmazon {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameAmazon];
    
    NSDictionary * responses = @{@{}:@{@"X-AMZ-CF-POP":@"EWR53-C2\n",@"X-Cache":@"Unknown from abcd"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeUnknown, parser.cdnNodeType);
    XCTAssertEqualObjects(@"EWR53-C2", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"Unknown", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"AMAZON", parser.cdnName);
}

- (void)testEdgecast {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameEdgecast];
    
    NSDictionary * responses = @{@{}:@{@"Server":@"ECAcc (mdr/67F3)\n",@"X-Cache":@"HIT"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"mdr", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"HIT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"EDGECAST", parser.cdnName);
}

- (void)testNosOtt {
    YBCdnParser * parser = [YBCdnParser createWithName:YouboraCDNNameNosOtt];
    
    NSDictionary * responses = @{@{}:@{@"X-NOS-Server":@"es1ottlb\n",@"X-Cache":@"HIT"}};
    
    [parser parseWithUrl:@"resource" andPreviousResponses:responses];
    
    // Check successful parsing
    XCTAssertEqual(YBCdnTypeHit, parser.cdnNodeType);
    XCTAssertEqualObjects(@"es1ottlb", parser.cdnNodeHost);
    XCTAssertEqualObjects(@"HIT", parser.cdnNodeTypeString);
    XCTAssertEqualObjects(@"NOSOTT", parser.cdnName);
}

#pragma mark - CdnTransformDoneDelegate
- (void)cdnTransformDone:(YBCdnParser *)cdnParser {
    self.transformDoneBlock(cdnParser);
}

@end
