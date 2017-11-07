//
//  YBConstants.h
//  YouboraLib
//
//  Created by Joan on 16/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//
#ifndef YBConstants_h
#define YBConstants_h

#import <Foundation/Foundation.h>

// Service constants
/** /data service */
FOUNDATION_EXPORT NSString * const YouboraServiceData;
/** /init service */
FOUNDATION_EXPORT NSString * const YouboraServiceInit;
/** /start service */
FOUNDATION_EXPORT NSString * const YouboraServiceStart;
/** /joinTime service */
FOUNDATION_EXPORT NSString * const YouboraServiceJoin;
/** /pause service */
FOUNDATION_EXPORT NSString * const YouboraServicePause;
/** /resume service */
FOUNDATION_EXPORT NSString * const YouboraServiceResume;
/** /seek service */
FOUNDATION_EXPORT NSString * const YouboraServiceSeek;
/** /bufferUnderrun service */
FOUNDATION_EXPORT NSString * const YouboraServiceBuffer;
/** /error service */
FOUNDATION_EXPORT NSString * const YouboraServiceError;
/** /stop service */
FOUNDATION_EXPORT NSString * const YouboraServiceStop;
/** /ping service */
FOUNDATION_EXPORT NSString * const YouboraServicePing;
/** /adInit service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdInit;
/** /adStart service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdStart;
/** /adJoin service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdJoin;
/** /adPause service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdPause;
/** /adResume service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdResume;
/** /adBufferUnderrun service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdBuffer;
/** /adStop service */
FOUNDATION_EXPORT NSString * const YouboraServiceAdStop;

// Lib version
FOUNDATION_EXPORT NSString * const YouboraLibVersion;

#endif
