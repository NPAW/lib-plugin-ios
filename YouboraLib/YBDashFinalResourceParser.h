//
//  YBDashFinalResourceParser.h
//  YouboraLib
//
//  Created by Mr.T on 26/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *
 * Class that read a dash (xml) string and using REGEX it will convert that xml to values
 *
 */
@interface YBDashFinalResourceParser : NSObject

/**
 * YBDashFinalResourceParser constructor .
 * @param regex the regex we want to get from dash (xml) string
 * @return a new YBDashFinalResourceParser instance
 */
-(instancetype)initWithRegex:(NSString*)regex;

/**
 * Method that will search for in dash (xml) string for the RegExp.
 * @param dash string to get the results
 * @return the result of the regex or nil case no regex found
 */
-(NSString*)parseForDash:(NSString*)dash;

@end
