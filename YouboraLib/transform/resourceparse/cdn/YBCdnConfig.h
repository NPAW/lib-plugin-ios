//
//  YBCdnConfig.h
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBParsableResponseHeader;

NS_ASSUME_NONNULL_BEGIN;

/**
 * Possible YOUBORA Cdn Types.
 */
typedef NS_ENUM(NSUInteger, YBCdnType) {
    /// Unknown cache type
    YBCdnTypeUnknown = 0,
    /// Cache hit
    YBCdnTypeHit = 1,
    /// Cache miss
    YBCdnTypeMiss = 2
};

/**
 * Block to delegate the logic of mapping the value returned in a CDN response header to
 * the YOUBORA expected values.
 *
 * This callback will be invoked whenever the CdnType is found in a CDN response header as
 * specified by a <YBParsableResponseHeader>.
 * The type param will contain whatever the capturing group in the <YBParsableResponseHeader.regexPattern>
 * has marked as Type in <YBParsableResponseHeader.element>.
 * @param type the string to be parsed matching a capturing group
 * @return the parsed <YBCdnType> based on the param content.
 */
typedef YBCdnType (^YBCdnTypeParserBlock) (NSString * type);

/**
 * An instance of this class has all the info and logic needed in order to "match" against a
 * particular CDN and get its node host and type (hit or miss).
 */
@interface YBCdnConfig : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/// The code that represents this CDN
@property (nonatomic, strong) NSString * code;

/// List of <YBParsableResponseHeader>
@property (nonatomic, strong) NSMutableArray<YBParsableResponseHeader *> * parsers;

/** 
 * A dict containing the request headers
 *
 * This headers will be added to the HEAD request used to get the CDN info. Some CDNs need
 * special headers to be set in a request in order to respond with the info we need.
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> * requestHeaders;

/**
 * CDN type parser
 * It will be used to parse the cdn info. Once the http HEAD
 * request is performed, this parser will be invoked with the http response to parse it and
 * extract the CDN host and/or type.
 */
@property (nonatomic, copy, nullable) YBCdnTypeParserBlock typeParser;

/**
 * Request method to use when requesting for info on the CDN
 * Default: HEAD
 */
@property (nonatomic, copy, nonnull) NSString * requestMethod;

/// ---------------------------------
/// @name Init
/// ---------------------------------
- (instancetype)initWithCode:(nullable NSString *) code;

@end

NS_ASSUME_NONNULL_END;
