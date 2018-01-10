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
 * This will get you the phone model
 * @returns Model name
 */
+ (NSString*) getModel;

/**
 * This will get you current OS version
 * @returns OS version
 */
+ (NSString*) getOSVersion;

/**
 * This will get you the brand
 * @returns brand
 */
+ (NSString*) getBrand;

/**
 * Maps all phone data to a JSON string
 * @returns formatted JSON string
 */
+ (NSString*) mapToJSONString;

@end
