//
//  YBCdnSwitchParser.h
//  YouboraLib
//
//  Created by Tiago Pereira on 11/08/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
This class will search every x seconds for a new cdn and notify the observers using KVO
 case a new cdn was found or not. This is not a mandatory parser because it can be actived
 or not, base on options defined by the user. That options must be passed on the initializer

@code
YBCdnSwitchParser *parser = [[YBCdnSwitchParser alloc] initWithIsCdnSwitchHeader:plugin.options.cdnSwitchHeader andCdnTTL:plugin.options.cdnTTL];
@endcode
*/
@interface YBCdnSwitchParser : NSObject


@property (readonly) BOOL cdnSwitchHeader;
@property (readonly) NSTimeInterval cdnTTL;

/**
Initialize of the class

@param cdnSwitchHeader BOOL value indicating if the cdn should start looking for new CDN or not
@param cdnTTL NSTimeInterval that will indicate to the parser which is the time interval in seconds that the parser should look for a new CDN

@return new parser instance
*/

-(instancetype)initWithIsCdnSwitchHeader:(BOOL)cdnSwitchHeader andCdnTTL:(NSTimeInterval)cdnTTL;


/**
 Method that will initialize timers and CDN switch, case the option to it is true and the resource is a valid resource
 
 @param resource String with the resource to get the CDN from
 */
-(void)start:(NSString*)resource;

/**
Method to return the last cdn that was fetched from the resource

@return cdn string or nil case the cdn wasn't found
*/
-(NSString*)getLastKnownCdn;

/**
Method to be called in the end of the adapter in order to release all the instances
*/
-(void)invalidate;

-(BOOL)isTimerRunning;
-(BOOL)isQueueRuning;
@end
