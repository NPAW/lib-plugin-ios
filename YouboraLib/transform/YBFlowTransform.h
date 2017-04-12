//
//  YBFlowTransform.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBTransformSubclass.h"

/**
 * This transform ensures that no requests will be sent before an /init or /start request.
 * As these are the two possible first requests that the API expects for a view.
 * <a href="http://developer.nicepeopleatwork.com/apidocs/swagger/html/?module=nqs7">API docs</a>.
 */
@interface YBFlowTransform : YBTransform

@end
