//
//  YBDeviceInfo.m
//  YouboraPluginAVPlayer
//
//  Created by Enrique Alfonso Burillo on 19/12/2017.
//  Copyright © 2017 Nice People At Work. All rights reserved.
//

#import "YBDeviceInfo.h"

#import "YBLog.h"

#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@interface YBDeviceInfo()

@property (nonatomic, strong) NSString * deviceModel;
@property (nonatomic, strong) NSString * deviceBrand;
@property (nonatomic, strong) NSString * deviceType;
@property (nonatomic, strong) NSString * deviceName;
@property (nonatomic, strong) NSString * deviceCode;
@property (nonatomic, strong) NSString * deviceOsName;
@property (nonatomic, strong) NSString * deviceOsVersion;
@property (nonatomic, strong) NSString * deviceBrowserName;
@property (nonatomic, strong) NSString * deviceBrowserVersion;
@property (nonatomic, strong) NSString * deviceBrowserType;
@property (nonatomic, strong) NSString * deviceBrowserEngine;

@end

@implementation YBDeviceInfo

// Extracted from https://stackoverflow.com/a/20062141 , they keep it pretty up to date
- (NSString*) getDeviceModel{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              @"iPhone11,2": @"iPhone XS",         //
                              @"iPhone11,4": @"iPhone XS Max",     //
                              @"iPhone11,6": @"iPhone XS Max",     // China
                              @"iPhone11,8": @"iPhone XR",
                              
                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return self.deviceModel == nil ? deviceName : self.deviceModel;
}

- (void) setDeviceModel:(NSString *)deviceModel {
    self.deviceModel = deviceModel;
}

- (NSString*) getDeviceBrand {
    //return @"Apple"; //Hardcoded since it's always apple made
    return self.deviceBrand == nil ? @"Apple" : self.deviceBrand;
}

- (void) setDeviceBrand:(NSString *)deviceBrand {
    self.deviceBrand = deviceBrand;
}

- (NSString*) getDeviceType {
    return self.deviceType;
}

- (void) setDeviceType:(NSString *)deviceType {
    self.deviceType = deviceType;
}

- (NSString*) getDeviceName {
    return self.deviceName;
}

- (void) setDeviceName:(NSString *)deviceName {
    self.deviceName = deviceName;
}

- (NSString*) getDeviceCode {
    return self.deviceCode;
}

- (void) setDeviceCode:(NSString *)deviceCode {
    self.deviceCode = deviceCode;
}

- (NSString*) getDeviceOsName {
    return self.deviceOsName;
}

- (void) setDeviceOsName:(NSString *)deviceOsName {
    self.deviceOsName = deviceOsName;
}

- (NSString*) getDeviceOSVersion {
    return self.deviceOsVersion == nil ? [UIDevice currentDevice].systemVersion: self.deviceOsVersion;
}

- (void) setDeviceOsVersion:(NSString *)deviceOsVersion {
    self.deviceOsVersion = deviceOsVersion;
}

- (NSString*) getDeviceBrowserName {
    return self.deviceBrowserName == nil ? @"" : self.deviceBrowserName;
}

- (void) setDeviceBrowserName:(NSString *)deviceBrowserName {
    self.deviceBrowserName = deviceBrowserName;
}

- (NSString*) getDeviceBrowserVersion {
    return self.deviceBrowserVersion == nil ? @"" : self.deviceBrowserVersion;
}

- (void) setDeviceBrowserVersion:(NSString *)deviceBrowserVersion {
    self.deviceBrowserVersion = deviceBrowserVersion;
}

- (NSString*) getDeviceBrowserType {
    return self.getDeviceBrowserType == nil ? @"" : self.getDeviceBrowserType;
}

- (void) setDeviceBrowserType:(NSString *)deviceBrowserType {
    self.deviceBrowserType = _deviceBrowserType;
}

- (NSString*) getDeviceBrowserEngine {
    return self.getDeviceBrowserEngine == nil ? @"" : self.getDeviceBrowserEngine;
}

- (void) setDeviceBrowserEngine:(NSString *)deviceBrowserEngine {
    self.deviceBrowserEngine = deviceBrowserEngine;
}

- (NSString*) mapToJSONString{
    
     NSError *error;
    
    NSDictionary* jsonObject = @{
                                 @"model" : [self getDeviceModel],
                                 @"osVersion" : [self getDeviceOSVersion],
                                 @"brand" : [self getDeviceBrand],
                                 @"deviceType" : [self getDeviceType],
                                 @"deviceCode" : [self getDeviceCode],
                                 @"osName" : [self getDeviceOsName],
                                 @"browserName" : [self getDeviceBrowserName],
                                 @"browserVersion" : [self getDeviceBrowserVersion],
                                 @"browserType" : [self getDeviceBrowserType],
                                 @"brownserEngine" : [self getDeviceBrowserEngine]
                                 };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        [YBLog error:@"Unable to generate device JSON"];
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end

