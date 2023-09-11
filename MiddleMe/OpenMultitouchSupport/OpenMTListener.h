//
//  OpenMTListener.h
//  OpenMultitouchSupport
//
//  Created by Takuto Nakamura on 2019/07/11.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

#ifndef OpenMTListener_h
#define OpenMTListener_h

#import <Foundation/Foundation.h>
#import "OpenMTInternal.h"

@interface OpenMTListener: NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;
- (void)count:(int)numTouches touches:(MTTouch [])touches;
- (BOOL)dead;

@property (assign, readwrite) BOOL listening;

@end

typedef void (^OpenMTEventCallback)(MTTouch *touches);

#endif /* OpenMTListener_h */
