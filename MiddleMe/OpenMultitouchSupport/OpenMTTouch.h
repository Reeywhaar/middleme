//
//  OpenMTTouch.h
//  OpenMultitouchSupport
//
//  Created by Takuto Nakamura on 2019/07/11.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

#ifndef OpenMTTouch_h
#define OpenMTTouch_h

#import <Foundation/Foundation.h>
#import "OpenMTInternal.h"

@interface OpenMTTouch: NSObject

- (id)initWithMTTouch:(MTTouch *)touch;

@property (assign, readonly) float posX, posY;

@end

#endif /* OpenMTTouch_h */
