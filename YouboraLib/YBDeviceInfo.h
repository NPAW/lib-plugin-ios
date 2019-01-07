//
//  YBDeviceInfo.h
//  YouboraPluginAVPlayer
//
//  Created by Enrique Alfonso Burillo on 19/12/2017.
//  Copyright © 2017 Nice People At Work. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBDeviceInfo : NSObject

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


/**
 * Maps all phone data to a JSON string
 * @returns formatted JSON string
 */
- (NSString*) mapToJSONString;

@end
