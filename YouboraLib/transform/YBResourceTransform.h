//
//  YBResourceTransform.h
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTransformSubclass.h"
#import "YBHlsParser.h"
#import "YBCdnParser.h"

@class YBPlugin;

NS_ASSUME_NONNULL_BEGIN;

/**
 * Parses resource urls to get transportstreams and CDN-related info.
 */
@interface YBResourceTransform : YBTransform<HlsTransformDoneDelegate, CdnTransformDoneDelegate>

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/*
@property(nonatomic, strong, readonly, nullable) NSString * nodeHost;
@property(nonatomic, strong, readonly, nullable) NSString * nodeType;
@property(nonatomic, strong, readonly, nullable) NSString * nodeTypeString;
@property(nonatomic, strong, readonly, nullable) NSString * resource;
@property(nonatomic, strong, readonly, nullable) NSString * cdnName;
*/
/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Initializer
 * @param plugin the plugin this ResourceTransform will use to get the info it needs
 */
-(instancetype) initWithPlugin:(YBPlugin *) plugin;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Start the execution. Can be called more than once. If already running, it will be ignored,
 * if ended it will restart.
 * @param originalResource the original resource
 */
- (void) begin:(NSString *) originalResource;

/**
 * Get the resource. If the transform is done, the real (parsed) resource will be returned
 * Otherwise the initial one is returned.
 * @return the initial or parsed resource
 */
- (NSString *) getResource;

/**
 * Get CDN name
 * @return the CDN name or nil if unknown
 */
- (NSString *) getCdnName;

/**
 * Get CDN node
 * @return the CDN node or nil if unknown
 */
- (NSString *) getNodeHost;

/**
 * Get CDN type, parsed from the type string
 * @return the CDN type
 */
- (NSString *) getNodeType;

/**
 * Get CDN type string, as returned in the cdn header response
 * @return the CDN type string
 */
- (NSString *) getNodeTypeString;

@end


NS_ASSUME_NONNULL_END;
