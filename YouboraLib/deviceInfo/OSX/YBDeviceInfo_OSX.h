//
//  YBDeviceInfo_OSX.h
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 27/05/2019.
//  Copyright © 2019 NPAW. All rights reserved.
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
