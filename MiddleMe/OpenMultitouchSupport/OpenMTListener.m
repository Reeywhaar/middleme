//
//  OpenMTListener.m
//  OpenMultitouchSupport
//
//  Created by Takuto Nakamura on 2019/07/11.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

#import "OpenMTListener.h"
#import "OpenMTInternal.h"

@implementation OpenMTListener {
@private
    OpenMTEventCallback _callback;
    __weak id _target;
    SEL _selector;
}

- (instancetype)init {
    if (self = [super init]) {
        _listening = YES;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    if (self = [self init]) {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (void)count:(int)numTouches touches:(MTTouch [])touches {
    if (self.dead || !self.listening) {
        return;
    }
    if (_callback) {
        _callback(touches);
        return;
    }
    if (_target) {
        ((void(*)(id, SEL, int, MTTouch[]))[_target methodForSelector:_selector])(_target, _selector, numTouches, touches);
        return;
    }
}

- (BOOL)dead {
    return !(_callback || (_target && _selector && [_target respondsToSelector:_selector]));
}

@end
