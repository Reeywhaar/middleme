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
#import "OpenMTEvent.h"

@interface OpenMTListener: NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;
- (void)listenToEvent:(OpenMTEvent *)event;
- (BOOL)dead;

@property (assign, readwrite) BOOL listening;

@end

#endif /* OpenMTListener_h */
