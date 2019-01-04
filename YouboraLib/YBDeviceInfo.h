//
//  YBDeviceInfo.h
//  YouboraPluginAVPlayer
//
//  Created by Enrique Alfonso Burillo on 19/12/2017.
//  Copyright © 2017 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBDeviceInfo : NSObject

/**
 * Getter for device model
 * @return device model
 */
- (NSString*) getDeviceModel;

- (void) setDeviceModel:(NSString *)deviceModel;

/**
 * Getter for device brand
 * @return device brand
 */
- (NSString*) getDeviceBrand;

- (void) setDeviceBrand:(NSString *)deviceBrand;

/**
 * Getter for device type
 * @return device type
 */
- (NSString*) getDeviceType;

- (void) setDeviceType:(NSString *)deviceType;

/**
 * Getter for device name
 * @return device name
 */
- (NSString*) getDeviceName;

- (void) setDeviceName:(NSString *)deviceName;

/**
 * Getter for device code
 * @return device code
 */
- (NSString*) getDeviceCode;

- (void) setDeviceCode:(NSString *)deviceCode;

/**
 * Getter for device OS name
 * @return device OS name
 */
- (NSString*) getDeviceOsName;

- (void) setDeviceOsName:(NSString *)deviceOsName;

/**
 * Getter for device OS version
 * @return device OS version
 */
- (NSString*) getDeviceOSVersion;

- (void) setDeviceOsVersion:(NSString *)deviceOsVersion;

/**
 * Getter for device browser name
 * @return device browser name
 */
- (NSString*) getDeviceBrowserName;

- (void) setDeviceBrowserName:(NSString *)deviceBrowserName;

/**
 * Getter for device browser version
 * @return device browser version
 */
- (NSString*) getDeviceBrowserVersion;

- (void) setDeviceBrowserVersion:(NSString *)deviceBrowserVersion;

/**
 * Getter for device browser type
 * @return device browser type
 */
- (NSString*) getDeviceBrowserType;

- (void) setDeviceBrowserType:(NSString *)deviceBrowserType;

/**
 * Getter for device browser engine
 * @return device browser engine
 */
- (NSString*) getDeviceBrowserEngine;

- (void) setDeviceBrowserEngine:(NSString *)deviceBrowserEngine;


/**
 * Maps all phone data to a JSON string
 * @returns formatted JSON string
 */
- (NSString*) mapToJSONString;

@end
