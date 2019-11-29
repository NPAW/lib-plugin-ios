//
//  YBDashParser.h
//  YouboraLib
//
//  Created by nice on 25/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DashTransformDoneDelegate;


/**
* Class that asynchronously parses an DASH resource in order to get to the location URL.
*
* Since the CDN detection is performed with the resource url, it is essential that this
* resource url is pointing to the CDN that is actually hosting the manifest.
*
*/
@interface YBDashParser : NSObject

/**
 * Returns the resource at this point
 * @return the resource
 */
-(NSString *_Nullable) getResource;

/**
 * Returns the last dash locaiton
 * @return the last location
 */
-(NSString *_Nullable) getLocation;

/**
* Add a delegate that will be notified once the parsing finishes.
* @param delegate the delegate to add
*/
-(void)addDashTransformDoneDelegate:(id<DashTransformDoneDelegate>_Nonnull) delegate;

/**
 * Remove a delegate
 * @param delegate the delegate to remove
 */
-(void)removeDashTransformDoneDelegate:(id<DashTransformDoneDelegate>_Nonnull) delegate;

/**
* Starts the Dash parsing from the given resource. The first (outside) call should set the
* parentResource to null.
*
* @param resource The resource url.
*/
-(void)parse:(NSString*_Nonnull)resource;

@end



@protocol DashTransformDoneDelegate

/**
* Invoked when the dash transform is done parsing
* @param parsedResource the final resource, or nil if couldn't be parsed
* @param parser the YBDashParser that is calling this delegate
*/
-(void)dashTransformDone:(nullable NSString *)parsedResource fromDashParser:(YBDashParser*_Nonnull) parser;

@end
