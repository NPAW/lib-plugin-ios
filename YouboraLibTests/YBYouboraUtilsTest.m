//
//  YBYouboraUtilsTest.m
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YouboraLib/YouboraLib-Swift.h"

@interface YBYouboraUtilsTest : XCTestCase

@end

@implementation YBYouboraUtilsTest

- (void)testStripProtocol {
    XCTAssertNil([YBYouboraUtils stripProtocol:nil]);
    XCTAssertEqualObjects(@"", [YBYouboraUtils stripProtocol:@""]);
    XCTAssertEqualObjects(@"google.com", [YBYouboraUtils stripProtocol:@"http://google.com"]);
    XCTAssertEqualObjects(@"google.com", [YBYouboraUtils stripProtocol:@"https://google.com"]);
    XCTAssertEqualObjects(@"google.com", [YBYouboraUtils stripProtocol:@"//google.com"]);
}

- (void)testAddProtocol {
    XCTAssertEqualObjects(@"https://", [YBYouboraUtils addProtocol:nil https:true]);
    XCTAssertEqualObjects(@"https://google.com", [YBYouboraUtils addProtocol:@"google.com" https:true]);
    XCTAssertEqualObjects(@"http://google.com", [YBYouboraUtils addProtocol:@"google.com" https:false]);
}

- (void)testRenditionString {
    XCTAssertEqualObjects(@"1920x1080@4.57Mbps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:4567452.9817]);
    XCTAssertEqualObjects(@"4.57Mbps", [YBYouboraUtils buildRenditionStringWithWidth:0 height:1080 andBitrate:4567452.9817]);
    XCTAssertEqualObjects(@"4.57Mbps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:0 andBitrate:4567452.9817]);
    XCTAssertEqualObjects(@"4.57Mbps", [YBYouboraUtils buildRenditionStringWithWidth:0 height:0 andBitrate:4567452.9817]);
    XCTAssertEqualObjects(@"1920x1080@457Kbps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:456745.9817]);
    XCTAssertEqualObjects(@"1920x1080@46Kbps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:45674.9817]);
    XCTAssertEqualObjects(@"1920x1080@5Kbps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:4567.9817]);
    XCTAssertEqualObjects(@"1920x1080@457bps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:456.9817]);
    XCTAssertEqualObjects(@"1920x1080", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:0]);
    XCTAssertEqualObjects(@"1920x1080", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:-123]);
    XCTAssertEqualObjects(@"1920x1080@1bps", [YBYouboraUtils buildRenditionStringWithWidth:1920 height:1080 andBitrate:1]);
}

- (void) testStringifyDict {
    
    // Dict -> json
    NSDictionary * dict = @{@"keyInt":@23,
                            @"keyDouble":@23.5,
                            @"keyArrayInt":@[@1,@2,@3,@4,@5],
                            @"keyArrayString":@[@"value",@"value2",@"value3"],
                            @"keyMap":@{@"key2String":@"StringValue",
                                        @"key2Number":@45
                            }};
    
    NSString * json = [YBYouboraUtils stringifyDictionary:dict];
    
    XCTAssertNotNil(json);
    
    NSError * error;
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNil(error);
    
    XCTAssertEqualObjects(dict, dictionary);
    
    // Assert empty dict and nil
    XCTAssertEqualObjects(@"{}", [YBYouboraUtils stringifyDictionary:@{}]);
    
    XCTAssertNil([YBYouboraUtils stringifyDictionary:nil]);
    
}

- (void)testParseNumber {
    NSNumber * def = @100;
    
    XCTAssertEqualObjects(@1.0, [YBYouboraUtils parseNumber:@1.0 orDefault:def]);
    XCTAssertEqualObjects(@1.0, [YBYouboraUtils parseNumber:@1.0 orDefault:nil]);
    XCTAssertEqualObjects(def, [YBYouboraUtils parseNumber:nil orDefault:def]);
    XCTAssertEqualObjects(def, [YBYouboraUtils parseNumber:@(INFINITY) orDefault:def]);
    XCTAssertEqualObjects(def, [YBYouboraUtils parseNumber:@(-INFINITY) orDefault:def]);
    XCTAssertEqualObjects(def, [YBYouboraUtils parseNumber:@(NAN) orDefault:def]);
}

- (void) testErrorBuilder {
    NSDictionary<NSString *, id> *dict;
    
    NSDictionary<NSString *, NSString *> * expectedDict = @{
        @"errorLevel" : @""
    };
    
    NSDictionary<NSString *, NSString *> * errorDict = [YBYouboraUtils buildErrorParams:dict];
    
    XCTAssertEqualObjects(errorDict[@"errorLevel"], expectedDict[@"errorLevel"]);
    
    dict = @{ @"errorLevel" : @"" };
    expectedDict = @{ @"errorLevel" : @""};
    
    errorDict = [YBYouboraUtils buildErrorParams:dict];
    XCTAssertEqualObjects(errorDict[@"errorLevel"], expectedDict[@"errorLevel"]);
    
    dict = @{ @"errorLevel" : @"something" };
    expectedDict = @{ @"errorLevel" : @"something"};
    
    errorDict = [YBYouboraUtils buildErrorParams:dict];
    XCTAssertEqualObjects(errorDict[@"errorLevel"], expectedDict[@"errorLevel"]);
    
    expectedDict = @{
        @"errorCode" : @"code",
        @"errorMsg" : @"msg",
        @"errorMetadata" : @"metadata",
        @"errorLevel" : @"level"
    };
    
    errorDict = [YBYouboraUtils buildErrorParamsWithMessage:@"msg" code:@"code" metadata:@"metadata" andLevel:@"level"];
    
    XCTAssertEqualObjects(expectedDict[@"errorCode"], errorDict[@"errorCode"]);
    XCTAssertEqualObjects(expectedDict[@"errorMsg"], errorDict[@"errorMsg"]);
    XCTAssertEqualObjects(expectedDict[@"errorMetadata"], errorDict[@"errorMetadata"]);
    XCTAssertEqualObjects(expectedDict[@"errorLevel"], errorDict[@"errorLevel"]);
    
    expectedDict = @{
        @"errorCode" : @"msg",
        @"errorMsg" : @"msg",
        @"errorMetadata" : @"metadata",
        @"errorLevel" : @"level"
    };
    
    errorDict = [YBYouboraUtils buildErrorParamsWithMessage:@"msg" code:nil metadata:@"metadata" andLevel:@"level"];
    
    XCTAssertEqualObjects(expectedDict[@"errorCode"], errorDict[@"errorCode"]);
    XCTAssertEqualObjects(expectedDict[@"errorMsg"], errorDict[@"errorMsg"]);
    XCTAssertEqualObjects(expectedDict[@"errorMetadata"], errorDict[@"errorMetadata"]);
    XCTAssertEqualObjects(expectedDict[@"errorLevel"], errorDict[@"errorLevel"]);
    
    expectedDict = @{
        @"errorCode" : @"code",
        @"errorMsg" : @"code",
        @"errorMetadata" : @"metadata",
        @"errorLevel" : @"level"
    };
    
    errorDict = [YBYouboraUtils buildErrorParamsWithMessage:nil code:@"code" metadata:@"metadata" andLevel:@"level"];
    
    XCTAssertEqualObjects(expectedDict[@"errorCode"], errorDict[@"errorCode"]);
    XCTAssertEqualObjects(expectedDict[@"errorMsg"], errorDict[@"errorMsg"]);
    XCTAssertEqualObjects(expectedDict[@"errorMetadata"], errorDict[@"errorMetadata"]);
    XCTAssertEqualObjects(expectedDict[@"errorLevel"], errorDict[@"errorLevel"]);
    
    expectedDict = @{
        @"errorCode" : @"PLAY_FAILURE",
        @"errorMsg" : @"PLAY_FAILURE",
        @"errorMetadata" : @"metadata",
        @"errorLevel" : @"level"
    };
    
    errorDict = [YBYouboraUtils buildErrorParamsWithMessage:nil code:nil metadata:nil andLevel:nil];
    
    XCTAssertEqualObjects(expectedDict[@"errorCode"], errorDict[@"errorCode"]);
    XCTAssertEqualObjects(expectedDict[@"errorMsg"], errorDict[@"errorMsg"]);
    XCTAssertEqualObjects(nil, errorDict[@"errorMetadata"]);
    XCTAssertEqualObjects(nil, errorDict[@"errorLevel"]);
}

- (void) testStringifyList {
    
    NSString *returnString = [YBYouboraUtils stringifyList:@[@"value1", @"value2"]];
    NSString *expectedString = @"[\"value1\",\"value2\"]";
    
    XCTAssertEqualObjects(expectedString, returnString);
}

- (void) testGetAppName {
    
    NSString *appName = [YBYouboraUtils getAppName];
    
    XCTAssertEqualObjects(appName, @"xctest");
}

- (void) testNoArray {
    XCTAssertFalse([YBYouboraUtils containsStringWithArray:nil value:@"tmp"]);
}

- (void) testNoValue {
    NSArray<NSString*> *array = @[@"tmp1", @"tmp2"];
    NSString *value = @"tmp";
    
    XCTAssertFalse([YBYouboraUtils containsStringWithArray: array value: value]);
}

- (void) testValue {
    NSArray<NSString*> *array = @[@"tmp1", @"tmp2", @"tmp"];
    NSString *value = @"tmp";
    
    XCTAssertTrue([YBYouboraUtils containsStringWithArray: array value: value]);
}

@end
