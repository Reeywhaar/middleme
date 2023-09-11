//
//  OpenMTInternal.h
//  OpenMultitouchSupport
//
//  Created by Takuto Nakamura on 2019/07/11.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//


#ifndef OpenMTInternal_h
#define OpenMTInternal_h

#import "OpenMTPublic.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef void *MTDeviceRef;
typedef void (*MTFrameCallbackFunction)(MTDeviceRef device, MTTouch touches[], int numTouches, double timestamp, int frame);
typedef void (*MTPathCallbackFunction)(MTDeviceRef device, long pathID, long state, MTTouch* touch);
typedef void (*MTImageCallbackFunction)(MTDeviceRef, void*, void*, void*);

CFArrayRef MTDeviceCreateList(void);
bool MTDeviceIsAvailable(void); // true if can create default device
MTDeviceRef MTDeviceCreateDefault(void);
MTDeviceRef MTDeviceCreateFromDeviceID(int64_t);
MTDeviceRef MTDeviceCreateFromService(io_service_t);
MTDeviceRef MTDeviceCreateFromGUID(uuid_t);
OSStatus MTDeviceStart(MTDeviceRef, int);
OSStatus MTDeviceStop(MTDeviceRef);
void MTDeviceRelease(MTDeviceRef);
bool MTDeviceIsRunning(MTDeviceRef);
bool MTDeviceIsBuiltIn(MTDeviceRef) __attribute__ ((weak_import));
bool MTDeviceIsOpaqueSurface(MTDeviceRef);

OSStatus MTDeviceGetSensorSurfaceDimensions(MTDeviceRef, int*, int*);
OSStatus MTDeviceGetSensorDimensions(MTDeviceRef, int*, int*);
OSStatus MTDeviceGetFamilyID(MTDeviceRef, int*);
OSStatus MTDeviceGetDeviceID(MTDeviceRef, uint64_t*) __attribute__ ((weak_import));
OSStatus MTDeviceGetDriverType(MTDeviceRef, int*);
OSStatus MTDeviceGetGUID(MTDeviceRef, uuid_t*);
void MTPrintImageRegionDescriptors(MTDeviceRef);


void MTEasyInstallPrintCallbacks(MTDeviceRef, BOOL, BOOL, BOOL, BOOL, BOOL, BOOL);

void MTRegisterContactFrameCallback(MTDeviceRef, MTFrameCallbackFunction);
void MTUnregisterContactFrameCallback(MTDeviceRef, MTFrameCallbackFunction);

void MTRegisterFullFrameCallback(MTDeviceRef, MTFrameCallbackFunction);
void MTUnregisterFullFrameCallback(MTDeviceRef, MTFrameCallbackFunction);

void MTRegisterPathCallback(MTDeviceRef, MTPathCallbackFunction);
void MTUnregisterPathCallback(MTDeviceRef, MTPathCallbackFunction);

// not work
extern MTImageCallbackFunction MTImagePrintCallback;
void MTRegisterMultitouchImageCallback(MTDeviceRef, MTImageCallbackFunction);
void MTRegisterImageCallback(MTDeviceRef, MTImageCallbackFunction, int, int);
void MTUnregisterImageCallback(MTDeviceRef, MTImageCallbackFunction);

#ifdef __cplusplus
}
#endif

#endif /* OpenMTInternal_h */

