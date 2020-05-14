//
//  YBResourceTransform.h
//  YouboraLib
//
//  Created by Joan on 24/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTransformSubclass.h"
#import "YBCdnParser.h"

@class YBPlugin;
@protocol YBResourceParser;
/**
 * Parses resource urls to get transportstreams and CDN-related info.
 */
@interface YBResourceTransform : YBTransform

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/**
 * Whether the resource parsing has finished or not
 */
@property(nonatomic, assign, readonly) bool isFinished;

/// ---------------------------------
/// @name Init
/// ---------------------------------
/**
 * Initializer
 * @param plugin Plugin to check all the info
 */
- (instancetype _Nonnull )initWithPlugin:(YBPlugin*_Nonnull)plugin;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Start the execution. Can be called more than once. If already running, it will be ignored,
 * if ended it will restart.
 * @param originalResource the original resource
 */
- (void) begin:(NSString *_Nullable) originalResource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat;

/**
 * Get the resource. If the transform is done, the real (parsed) resource will be returned
 * Otherwise the initial one is returned.
 * @return the initial or parsed resource
 */
- (NSString * _Nullable) getResource;

/**
* Check if user didn't define a transport format and if there's a valid transport format
* returns it
* @return transport format present in manifest or nil
*/
- (nullable NSString*) getTransportFormat;

/**
 * Get CDN name
 * @return the CDN name or nil if unknown
 */
- (nullable NSString *) getCdnName;

/**
 * Get CDN node
 * @return the CDN node or nil if unknown
 */
- (nullable NSString *) getNodeHost;

/**
 * Get CDN type, parsed from the type string
 * @return the CDN type
 */
- (nullable NSString *) getNodeType;

/**
 * Get CDN type string, as returned in the cdn header response
 * @return the CDN type string
 */
- (nullable NSString *) getNodeTypeString;

-(void)parse:(id<YBResourceParser> _Nullable)parser currentResource:(NSString* _Nullable)resource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat;
-(void)requestAndParse:(id<YBResourceParser> _Nullable)parser currentResource:(NSString* _Nullable)resource userDefinedTransportFormat:(NSString* _Nullable)definedTransportFormat;
-(id<YBResourceParser> _Nullable)getNextParser:(id<YBResourceParser> _Nullable)parser;
@end
