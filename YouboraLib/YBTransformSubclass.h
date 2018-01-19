//
//  YBTransformSubclass.h
//  YouboraLib
//
//  Created by Joan on 20/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#ifndef YBTransformSubclass_h
#define YBTransformSubclass_h

#import "YBTransform.h"

/*
 * Extension for YBTransform.
 * Definition of "protected" methods.
 * Only incude this header file when subclassing <YBTransform>
 */
@interface YBTransform()

/**
 * Whether the Transform is currently working or not.
 * @see <done>
 */
@property (nonatomic, assign) bool isBusy;

/**
 * Wheter the Transform has to send Request or not
 */
@property (nonatomic, assign) bool sendRequest;

/**
 * Sets the isBusy flag to true and notifies all the registered <TransformDoneListener>s
 * with the <addTransformDoneListener:> method.
 */
- (void) done;

@end

#endif /* YBTransformSubclass_h */
