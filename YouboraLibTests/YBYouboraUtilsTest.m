//
//  YBYouboraUtilsTest.m
//  YouboraLib
//
//  Created by Joan on 21/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YBYouboraUtils.h"

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

@end
