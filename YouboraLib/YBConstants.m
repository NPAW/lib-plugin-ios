//
//  YBConstants.m
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBConstants.h"

#define MACRO_NAME(f) #f
#define MACRO_VALUE(f)  MACRO_NAME(f)

#ifdef YOUBORALIB_VERSION
NSString * const YouboraLibVersion = @MACRO_VALUE(YOUBORALIB_VERSION);
#endif
