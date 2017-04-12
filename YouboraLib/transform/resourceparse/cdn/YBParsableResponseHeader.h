//
//  YBParsableResponseHeader.h
//  YouboraLib
//
//  Created by Joan on 31/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN;

/**
 * Possible different bits of info we can get from a header.
 * @see <YBParsableResponseHeader.regexPattern>
 */
typedef NS_ENUM(NSUInteger, YBCdnHeaderElement) {
    /// Host
    YBCdnHeaderElementHost,
    /// Type
    YBCdnHeaderElementType,
    /// Host, then type
    YBCdnHeaderElementHostAndType,
    /// Type, then host
    YBCdnHeaderElementTypeAndHost,
    /// CDN name
    YBCdnHeaderElementName
};

/**
 * An instance of this class informs what info to extract from a particular header response for
 * a given CDN.
 */
@interface YBParsableResponseHeader : NSObject

/// ---------------------------------
/// @name Init
/// ---------------------------------

/**
 * Constructor
 *
 * @param element the expected info from this header response
 * @param headerName name of the header where the information can be found
 * @param regexPattern pattern to extract the information.
 */
- (instancetype)initWithElement:(YBCdnHeaderElement) element headerName:(nullable NSString *) headerName andRegexPattern:(NSString *) regexPattern;

/// ---------------------------------
/// @name Public methods
/// ---------------------------------

/**
 * What info should this ParsableResponseHeader should extract from the header.
 */
@property(nonatomic, assign) YBCdnHeaderElement element;

/**
 * The name of the header where the information can be found in the CDN response
 */
@property(nonatomic, strong, nullable) NSString * headerName;

/**
 * Pattern to extract the information. This works in conjunction with <element>.
 *
 * If only one element is expected, Host, Type or Name, the pattern should contain one capturing group.
 * Likewise, two capturing groups are expected if two bits of information are desired, with HostAndType
 * or TypeAndHost
 */
@property(nonatomic, strong) NSString * regexPattern;

@end

NS_ASSUME_NONNULL_END;
