//
//  OpenMTTouch.m
//  OpenMultitouchSupport
//
//  Created by Takuto Nakamura on 2019/07/11.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

#import "OpenMTTouch.h"

@implementation OpenMTTouch

- (id)initWithMTTouch:(MTTouch *)touch {
    if (self = [super init]) {
        _posX = touch->normalizedPosition.position.x;
        _posY = touch->normalizedPosition.position.y;
    }
    return self;
}

@end

