#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BackendTask.h"
#import "Constant.h"
#import "DeviceInformation.h"
#import "Md5.h"

FOUNDATION_EXPORT double NetWorkKitVersionNumber;
FOUNDATION_EXPORT const unsigned char NetWorkKitVersionString[];

