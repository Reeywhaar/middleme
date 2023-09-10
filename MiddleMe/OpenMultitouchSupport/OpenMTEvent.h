//
//  OpenMTEvent.h
//  OpenMultitouchSupport
//
//  Created by Takuto Nakamura on 2019/07/11.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

#ifndef OpenMTEvent_h
#define OpenMTEvent_h

#import <Foundation/Foundation.h>

@interface OpenMTEvent: NSObject

@property (strong, readwrite) NSArray *touches;
@property (assign, readwrite) int deviceID;
@property (assign, readwrite) int frameID;
@property (assign, readwrite) double timestamp;

@end

typedef void (^OpenMTEventCallback)(OpenMTEvent *event);

#endif /* OpenMTEvent_h */
