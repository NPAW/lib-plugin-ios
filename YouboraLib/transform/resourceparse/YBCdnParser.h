//
//  YBCdnParser.h
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBCdnConfig.h"

@protocol CdnTransformDoneDelegate;

NS_ASSUME_NONNULL_BEGIN;

FOUNDATION_EXPORT NSString * const YouboraCDNNameLevel3;
FOUNDATION_EXPORT NSString * const YouboraCDNNameCloudfront;
FOUNDATION_EXPORT NSString * const YouboraCDNNameAkamai;
FOUNDATION_EXPORT NSString * const YouboraCDNNameHighwinds;
FOUNDATION_EXPORT NSString * const YouboraCDNNameFastly;
FOUNDATION_EXPORT NSString * const YouboraCDNNameBalancer;
FOUNDATION_EXPORT NSString * const YouboraCDNNameTelefonica;
FOUNDATION_EXPORT NSString * const YouboraCDNNameAmazon;

/**
 * Class that asynchronously tries to get information about the CDN where a given resource is
 * hosted.
 * The info we care about is the CDN code itself, the node host and node type.
 *
 * The CDN is queried with http HEAD requests. This only will work if the customer has properly
 * configured their CDN.
 *
 * When HEAD requests are performed against the resources, the CDN returns a set of headers that
 * containing info about the cdn header and / or cdn type.
 *
 * Each CDN is different; some require special headers to be set when the HEAD request is performed
 * and others don't. Also, the info can come back in any fashion of ways, sometimes both type and host
 * come in the same response header while sometimes they're in different headers. The format of these
 * response headers is also different from CDN to CDN, so a different regex is used for each CDN.
 *
 * Lastly, as the values indicating the CDN type are also different, we need a specific mapping for
 * each one.
 *
 * This is the process to add a new CDN to the parser.
 * <ol>
 *      <li>CDN code. The class that holds all the needed info is YBCdnConfig. It should be
 *      constructed passing the CDN code that represents this CDN. This is a YOUBORA code and can
 *      be found <a href="http://mapi.youbora.com:8081/cdns">here</a>.</li>
 *      <li>Response headers. The CDN will answer the HEAD request with headers that contain the
 *      info we're looking for. We should add as many YBParsableResponseHeader as needed.
 *      The constructor needs three things:
 *      <ul>
 *          <li>Element. Specify if this header will contain the Host, Type, or both. Note that HostAndType 
 *          is not the same as TypeAndHost.
 *          The order is the same as how will they will appear in the header response value. This can
 *          also have the "Name" value, indicating that this field value is actually the CDN name</li>
 *          <li>Header response name. Header from where the info will be got from.</li>
 *          <li>Regex. Regular expression to extract host and/or type. If only one of them is expected
 *          define one capturing group, and two otherwise.</li>
 *      </ul>
 *      </li>
 *      <li>Request headers. Add headers to YBCdnConfig's requestHeaders if this CDN
 *      requires special headers to be set in order to respond with the info we want.</li>
 *      <li>Type parser. Once the CDN Type value is found (using one of the previously set
 *      YBParsableResponseHeader) this parser will be called passing it the found value
 *      as a String. This parser should return Hit or Miss depending on the Type string parameter.
 *      If it doesn't match with what would you expect,
 *      return Unknown instead.</li>
 * </ol>
 */
@interface YBCdnParser : NSObject

/// ---------------------------------
/// @name Public properties
/// ---------------------------------

/**
 * The request responses from this CdnParser.
 *
 * This is filled with the responses from the constructor, or created empty if nil.
 * Then the performed request response (if any) is added to this map.
 * Call this method after "using" the CdnParser and pass the responses to the following
 * CdnParser so it can use the responses if it applies.
 */
@property(nonatomic, strong, readonly) NSMutableDictionary * responses;

/**
 * Cdn node host
 */
@property(nonatomic, strong, readonly) NSString * cdnNodeHost;

/**
 * Cdn node type as raw value parsed from the header response
 */
@property(nonatomic, assign, readonly) YBCdnType cdnNodeType;

/**
 * Parsed node type as returned by a YBCdnTypeParserBlock (YBCdnConfig)
 */
@property(nonatomic, strong, readonly) NSString * cdnNodeTypeString;

/**
 * The Cdn name. This will be the code specified in the YBCdnConfig initialiser
 * unless YBCdnHeaderElementName is specified in a YBParsableResponseHeader and a match is found.
 */
@property(nonatomic, strong, readonly) NSString * cdnName;

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Initialises the CdnParser with a YBCdnConfig
 * @param cdnConfig the cdn config to use with this parser
 */
- (instancetype)initWithCdnConfig:(YBCdnConfig *) cdnConfig;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * Start parsing the CDN for the given resource.
 * @param url the resource url to parse the CDN
 * @param responses previous http responses that may be re-used so we can avoid making them again
 */
- (void) parseWithUrl:(NSString *)url andPreviousResponses:(nullable NSDictionary *) responses;

/**
 * Add a delegate that will be notified whenever this CdnParser finishes.
 * @param delegate the delegate to add.
 */
- (void) addCdnTransformDelegate:(id<CdnTransformDoneDelegate>) delegate;

/**
 * Removes a delegate
 * @param delegate the delegate to remove
 */
- (void) removeCdnTransformDelegate:(id<CdnTransformDoneDelegate>) delegate;

/// ---------------------------------
/// @name Static methods
/// ---------------------------------

/**
 * This is a special case. A custom CDN definition
 * that tries to get the CDN name directly from one of the headers. This method can be used
 * as a shortcut to creating a new CDN definition.
 * This is usually used with DNS-based load balance services, such as Cedexis.
 * @param cdnNameHeader the header response name where to get the CDN name from.
 */
+ (void) setBalancerHeaderName:(NSString *) cdnNameHeader;

/**
 * Create one of the pre-defined CDN definitions.
 * @param cdnName Name of the CDN
 * @return a YBCdnParser instance or nil if the names does not match any CDN
 */
+ (nullable YBCdnParser *) createWithName:(NSString *) cdnName;

/**
 * Adds the given CDN config to the cdn definitions.
 * @param cdnName The name that will identify the CDN
 * @param cdnConfig The YBCdnConfig that defines the CDN
 */
+ (void) addCdn:(NSString *) cdnName withConfig:(YBCdnConfig *) cdnConfig;

/**
 * Returns the current dict of defined cdns
 * @return the current dict of defined cdns
 */
+ (NSDictionary<NSString *, YBCdnConfig *> *) definedCdns;

@end

/**
 * Callback protocol to inform observers that the parsing is done.
 */
@protocol CdnTransformDoneDelegate

@required

/**
 * Invoked when the cdn transform is done parsing
 * @param cdnParser the CdnTransform that is calling this delegate
 */
- (void) cdnTransformDone:(YBCdnParser *) cdnParser;

@end

NS_ASSUME_NONNULL_END;
