//
//  YBDeviceInfoTest.m
//  YouboraLib iOS
//
//  Created by Enrique Alfonso Burillo on 04/01/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import <Foundation/Foundation.h>

#import "YouboraLib/YouboraLib-Swift.h"

@interface YBDeviceInfoTest : XCTestCase

@end

@implementation YBDeviceInfoTest

- (void) testDeviceInfoGetter {
    YBDeviceInfo *deviceInfo = [[YBDeviceInfo alloc] init];
    XCTAssertTrue([deviceInfo.deviceBrand isEqualToString:@"Apple"]);
    XCTAssertNil(deviceInfo.deviceModel);
    XCTAssertNil(deviceInfo.deviceType);
    XCTAssertNil(deviceInfo.deviceCode);
    XCTAssertNil(deviceInfo.deviceOsName);
    XCTAssertNil(deviceInfo.deviceOsVersion);
    XCTAssertNil(deviceInfo.deviceName);
}

- (void) testDeviceInfoSetter {
    YBDeviceInfo* deviceInfo = [self getCompleteDeviceInfo];
    
    XCTAssertEqual(@"brand", deviceInfo.deviceBrand);
    XCTAssertEqual(@"model", deviceInfo.deviceModel);
    XCTAssertEqual(@"type", deviceInfo.deviceType);
    XCTAssertEqual(@"code", deviceInfo.deviceCode);
    XCTAssertEqual(@"osName", deviceInfo.deviceOsName);
    XCTAssertEqual(@"osVersion", deviceInfo.deviceOsVersion);
    XCTAssertEqual(@"name", deviceInfo.deviceName);
    XCTAssertEqual(@"browser name", deviceInfo.deviceBrowserName);
    XCTAssertEqual(@"browser version", deviceInfo.deviceBrowserVersion);
    XCTAssertEqual(@"browser type", deviceInfo.deviceBrowserType);
    XCTAssertEqual(@"browser engine", deviceInfo.deviceBrowserEngine);
}

- (void) testMapJsonStringWithDefaultValues {
    NSString *deviceInfoString = [[[YBDeviceInfo alloc] init] mapToJSONString];
    NSDictionary *jsonDict = [self convertToJsonDataWithString:deviceInfoString];
    
    XCTAssertNotNil(jsonDict[@"brand"]);
    XCTAssertNotNil(jsonDict[@"model"]);
    XCTAssertNil(jsonDict[@"deviceType"]);
    XCTAssertNil(jsonDict[YBConstantsRequest.deviceCode]);
    XCTAssertNil(jsonDict[@"osName"]);
    XCTAssertNotNil(jsonDict[@"osVersion"]);
    XCTAssertNotNil(jsonDict[@"browserName"]);
    XCTAssertNotNil(jsonDict[@"browserVersion"]);
    XCTAssertNotNil(jsonDict[@"browserType"]);
    XCTAssertNotNil(jsonDict[@"browserEngine"]);
    
}

- (void) testMapJsonStringWithCompleteValues {
    NSString *deviceInfoString = [[self getCompleteDeviceInfo] mapToJSONString];
    NSDictionary *jsonDict = [self convertToJsonDataWithString:deviceInfoString];
    
    XCTAssertTrue([@"brand" isEqual: jsonDict[@"brand"]]);
    XCTAssertTrue([@"model" isEqual: jsonDict[@"model"]]);
    XCTAssertTrue([@"type" isEqual: jsonDict[@"deviceType"]]);
    XCTAssertTrue([@"code" isEqual: jsonDict[YBConstantsRequest.deviceCode]]);
    XCTAssertTrue([@"osName" isEqual:jsonDict[@"osName"]]);
    XCTAssertTrue([@"osVersion" isEqual:jsonDict[@"osVersion"]]);
    XCTAssertTrue([@"browser name" isEqual:jsonDict[@"browserName"]]);
    XCTAssertTrue([@"browser version" isEqual:jsonDict[@"browserVersion"]]);
    XCTAssertTrue([@"browser type" isEqual:jsonDict[@"browserType"]]);
    XCTAssertTrue([@"browser engine" isEqual:jsonDict[@"browserEngine"]]);
    
    XCTAssertNil(jsonDict[@"deviceName"]);
    
}

- (void) testDeviceCodeNotFound {
    YBDeviceInfo * deviceInfo = [[YBDeviceInfo alloc] init];
    NSString * deviceModel = [deviceInfo deviceNameWithCode:@"iPod"];
    XCTAssertEqualObjects(deviceModel, @"iPod Touch");
    
    deviceModel = [deviceInfo deviceNameWithCode:@"iPad"];
    XCTAssertEqualObjects(deviceModel, @"iPad");
    
    deviceModel = [deviceInfo deviceNameWithCode:@"iPhone"];
    XCTAssertEqualObjects(deviceModel, @"iPhone");
    
    deviceModel = [deviceInfo deviceNameWithCode:@"AppleTV"];
    XCTAssertEqualObjects(deviceModel, @"Apple TV");
    
    deviceModel = [deviceInfo deviceNameWithCode:@"fake code"];
    XCTAssertEqualObjects(deviceModel, @"Unknown");
}

- (YBDeviceInfo*) getCompleteDeviceInfo {
    YBDeviceInfo *deviceInfo = [[YBDeviceInfo alloc] init];
    [deviceInfo setDeviceBrand:@"brand"];
    [deviceInfo setDeviceModel:@"model"];
    [deviceInfo setDeviceType:@"type"];
    [deviceInfo setDeviceCode:@"code"];
    [deviceInfo setDeviceOsName:@"osName"];
    [deviceInfo setDeviceOsVersion:@"osVersion"];
    [deviceInfo setDeviceName:@"name"];
    [deviceInfo setDeviceBrowserName:@"browser name"];
    [deviceInfo setDeviceBrowserVersion:@"browser version"];
    [deviceInfo setDeviceBrowserType:@"browser type"];
    [deviceInfo setDeviceBrowserEngine:@"browser engine"];
    
    return deviceInfo;
}

- (NSDictionary*) convertToJsonDataWithString: (NSString*) jsonString {
    NSError *error;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary *)jsonObject;
        }
    }
    return nil;
}

@end
