//
//  DeviceInformation.h
//  FKSDK
//
//  Created by bcb on 2018/8/3.
//  Copyright © 2018年 bcb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInformation : NSObject
// 当前手机型号
+ (NSString *)getCurrentDeviceMode;

// 网络状态
+ (NSString *)getCurrentNetworkStatus;

// 设备UDID
+ (NSString *)getDeviceId;

// 获取uuid
+ (NSString *)getUUID;

// IP地址
+ (NSString *)getCurrentIp;

// 客户端版本
+ (NSString *)getAppVersion;

// 系统版本
+ (NSString *)getOSVersion;

// 获取分辨率
+ (NSString *)getResolution;
@end
