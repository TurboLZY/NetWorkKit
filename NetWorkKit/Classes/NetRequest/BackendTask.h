//
//  Backend.h
//  haohuo
//
//  Created by will on 2018/7/2.
//  Copyright © 2018 baicaibang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnSuccess)(NSDictionary* response);
typedef void(^OnFailed)(NSDictionary* response, NSString* message);

@interface BackendTask : NSObject

@property (nonatomic, copy) NSString *userID;

- (BackendTask * (^)(NSString *))api;
- (BackendTask * (^)(NSDictionary *))content;
- (BackendTask * (^)(NSDictionary *))jointUrl;
- (BackendTask * (^)(OnSuccess))onSuccess;
- (BackendTask * (^)(OnFailed))onFailed;
- (BackendTask * (^)(void))run;
- (BackendTask * (^)(void))get;
- (BackendTask * (^)(NSData *,NSString *,NSString *))uploadFile;
@end
