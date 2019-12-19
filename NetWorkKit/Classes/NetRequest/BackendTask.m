//
//  Backend.m
//  haohuo
//
//  Created by liuhx on 2018/7/2.
//  Copyright © 2018 will. All rights reserved.
//

#import "BackendTask.h"
#import "DeviceInformation.h"
#import "Md5.h"
#import "Constant.h"
NSString *const kFKDefaultSecret = @"bc7#$86ea8c@00*4";

static NSURLSession *gWorkerSession = nil;
static NSOperationQueue *gWorkerQueue = nil;
static NSDictionary *gWorkerCommon = nil;


//remove null or undefined in json object
static id AFJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions)
{
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = [(NSDictionary *)JSONObject objectForKey:key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [mutableDictionary setObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions) forKey:key];
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}

@interface BackendTask ()

@property (nonatomic) NSString* taskApi;
@property (nonatomic, strong) NSDictionary* taskContent;
@property (nonatomic,  copy) OnSuccess taskOnSuccess;
@property (nonatomic,  copy) OnFailed taskOnFailed;

@end

@implementation BackendTask

- (BackendTask * (^)(NSString *))api {
    return ^id(NSString *interface) {
        self.taskApi = [kWS_ServerAddress stringByAppendingString:interface];
        return self;
    };
}


- (BackendTask * (^)(NSDictionary *))content {
    return ^id(NSDictionary *content) {
        self.taskContent = content;
        return self;
    };
}

- (BackendTask * (^)(NSDictionary *))jointUrl {
    return ^id(NSDictionary *content) {
        NSMutableString *url = [NSMutableString stringWithString:self.taskApi];
        for (int i=0; i<content.allKeys.count; i++) {
            NSString *sign;
            i==0 ? (sign = @"?") : (sign = @"&");
            NSString *key = content.allKeys[i];
            NSString *str = [NSString stringWithFormat:@"%@%@=%@", sign, key, content[key]];
            [url appendString:str];
        }
        self.taskApi = url;
        return self;
    };
}

- (BackendTask * (^)(OnSuccess))onSuccess {
    return ^id(OnSuccess onSuccess) {
        self.taskOnSuccess = onSuccess;
        return self;
    };
}

- (BackendTask * (^)(OnFailed))onFailed {
    return ^id(OnFailed onFailed) {
        self.taskOnFailed = onFailed;
        return self;
    };
}


- (BackendTask * (^)(NSData *,NSString *,NSString *))uploadFile {
    return ^id(NSData *file, NSString *name, NSString *fileName) {
        [self generateWorkerQueue];
        [self generateWorkerCommon];
        [self generateWorkerSession];
        [gWorkerQueue addOperationWithBlock:^{
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
            //Private Header
            NSString *version = gWorkerCommon[@"version"];
            NSString *userId = self.userID;
            NSString *key = [NSString stringWithFormat:@"ppgt/%@%@%@%@%@request", self.taskApi, kWS_Platform, version, kWS_Source, userId];
            key = [Md5 encode:key];
            [request setValue:version forHTTPHeaderField:@"Version"];
            [request setValue:kWS_Source forHTTPHeaderField:@"Source"];//渠道
            [request setValue:key forHTTPHeaderField:@"key"];
            [request setValue:@"auth" forHTTPHeaderField:@"Auth"];
            [request setValue:@"authtime" forHTTPHeaderField:@"authtime"];
            [request setValue:userId forHTTPHeaderField:@"UserId"];
            
            //
            //分界线的标识符
            NSString *TWITTERFON_FORM_BOUNDARY = @"e18a29aa-5f23-47ce-a6be-f715b75a6fe6";
            //分界线 --AaB03x
            NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
            //结束符 --AaB03x--
            NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
            /*
             上传格图片格式：
             --AaB03x
             Content-Disposition: form-data; name="file"; filename="currentImage.png"
             Content-Type: image/png
             */
            //http body的字符串
            NSMutableString *body=[[NSMutableString alloc]init];
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            [body appendFormat:@"%@", [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n",name,fileName]];
            //声明结束符：--AaB03x--
            NSString *end = [[NSString alloc]initWithFormat:@"\r\n\r\n%@\r\n",endMPboundary];
            //声明myRequestData，用来放入http body
            NSMutableData *requestData = [NSMutableData data];
            //将body字符串转化为UTF8格式的二进制
            [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [requestData appendData:file];
            //加入结束符 --AaB03x--
            [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
            
            //设置HTTPHeader中Content-Type的值
            NSString *contentType = [[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
            //设置HTTPHeader
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            //设置Content-Length
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
            //设置http body
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:requestData];
            [request setURL:[self generateURL]];
            [request setTimeoutInterval:30.0];
            
            [[gWorkerSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    [self invokeOnFailed:nil error:[error localizedDescription]];
                    return;
                }
                NSHTTPURLResponse* httpUrlResponse = (NSHTTPURLResponse*)response;
                NSInteger code = [httpUrlResponse statusCode];
                if (code != 200) {
                    [self invokeOnFailed:nil error:@"network error"];
                    return;
                }
                if (data) {
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    //remove null or undefined in json object
                    json = AFJSONObjectByRemovingKeysWithNullValues(json, (NSJSONReadingOptions)0);
                    if (!json) {
                        [self invokeOnFailed:nil error:@"json error"];
                        return;
                    }
                    if ([json[@"code"] integerValue] == 0 ) {
                        [self invokeOnSuccess:json];
                    } else {
                        [self invokeOnFailed:json error:json[@"msg"]];
                    }
                } else {
                    [self invokeOnFailed:nil error:@"what the hell"];
                }
            }] resume];
        }];
        return self;
    };
}

- (BackendTask * (^)(void))run {
    return ^id() {
        [self generateWorkerQueue];
        [self generateWorkerCommon];
        [self generateWorkerSession];
        [gWorkerQueue addOperationWithBlock:^{
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString *accessToken;
            //[UserConfig isLogin] ? (accessToken = [UserConfig getAccessToken]) : (accessToken = kWS_AccessToken_Default);
            NSString *authorization = [NSString stringWithFormat:@"Bearer %@", accessToken];
            [request setValue:authorization forHTTPHeaderField:@"Authorization"];
            /*
            NSString *version = gWorkerCommon[@"version"];
            NSString *userId = [UserConfig getUserid];
            NSString *key = [NSString stringWithFormat:@"ppgt/%@%@%@%@%@request", self.taskApi, kWS_Platform, version, kWS_Source, userId];
            key = [Md5 encode:key];
            [request setValue:version forHTTPHeaderField:@"Version"];
            [request setValue:kWS_Source forHTTPHeaderField:@"Source"];//渠道
            [request setValue:key forHTTPHeaderField:@"key"];
            [request setValue:[UserConfig getAuth] forHTTPHeaderField:@"Auth"];
            [request setValue:[UserConfig getAuthtime] forHTTPHeaderField:@"authtime"];
            [request setValue:userId forHTTPHeaderField:@"UserId"];
             */
            [request setURL:[self generateURL]];
            NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
            //实际参数
            if (self.taskContent) {
                [req addEntriesFromDictionary:self.taskContent];
            }
            NSData *reqData = [NSJSONSerialization dataWithJSONObject:req options:NSJSONWritingPrettyPrinted error:nil];
            //测试用
            NSString *str11 = [[NSString alloc] initWithData:reqData encoding:NSUTF8StringEncoding];
            
            //NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPBody:reqData];
            [[gWorkerSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    [self invokeOnFailed:nil error:[error localizedDescription]];
                    return;
                }
                NSHTTPURLResponse* httpUrlResponse = (NSHTTPURLResponse*)response;
                NSInteger code = [httpUrlResponse statusCode];
                NSLog(@"网络请求:%@ --- 接口返回code：%ld",[self generateURL],(long)code);
                if (code == 401) {
                    [self unauthorized];
                    return;
                }
                if (code != 200) {
                    [self invokeOnFailed:nil error:@"network error"];
                    return;
                }
                if (data) {
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    //remove null or undefined in json object
                    json = AFJSONObjectByRemovingKeysWithNullValues(json, (NSJSONReadingOptions)0);
                    if (!json) {
                        [self invokeOnFailed:nil error:@"json error"];
                        return;
                    }
                    NSDictionary *result = json[@"result"];
                    if (!result) {
                        [self invokeOnFailed:nil error:@"no result"];
                        return;
                    }
                    if ([result[@"code"] integerValue] == 0 ) {
                        [self invokeOnSuccess:result];
                    } else {
                        [self invokeOnFailed:result error:result[@"msg"]];
                    }
                } else {
                     [self invokeOnFailed:nil error:@"what the hell"];
                }
            }] resume];
        }];
        return self;
    };
}

- (BackendTask * (^)(void))get {
    return ^id() {
        [self generateWorkerQueue];
        [self generateWorkerCommon];
        [self generateWorkerSession];
        [gWorkerQueue addOperationWithBlock:^{
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString *accessToken;
            //[UserConfig isLogin] ? (accessToken = [UserConfig getAccessToken]) : (accessToken = kWS_AccessToken_Default);
            NSString *authorization = [NSString stringWithFormat:@"Bearer %@", accessToken];
            [request setValue:authorization forHTTPHeaderField:@"Authorization"];
            [request setURL:[self generateURL]];
            
            [[gWorkerSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    [self invokeOnFailed:nil error:[error localizedDescription]];
                    return;
                }
                NSHTTPURLResponse* httpUrlResponse = (NSHTTPURLResponse*)response;
                NSInteger code = [httpUrlResponse statusCode];
                
                if (code == 401) {
                    [self unauthorized];
                    return;
                }
                if (code != 200) {
                    [self invokeOnFailed:nil error:@"network error"];
                    return;
                }
                if (data) {
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    //remove null or undefined in json object
                    json = AFJSONObjectByRemovingKeysWithNullValues(json, (NSJSONReadingOptions)0);
                    if (!json) {
                        [self invokeOnFailed:nil error:@"json error"];
                        return;
                    }
                    NSDictionary *result = json[@"result"];
                    if (!result) {
                        [self invokeOnFailed:nil error:@"no result"];
                        return;
                    }
                    if ([result[@"code"] integerValue] == 0 ) {
                        [self invokeOnSuccess:result];
                    } else {
                        [self invokeOnFailed:result error:result[@"msg"]];
                    }
                } else {
                    [self invokeOnFailed:nil error:@"what the hell"];
                }
            }] resume];
        }];
        return self;
    };
}

- (NSURL *)generateURL {
    return [NSURL URLWithString:self.taskApi];
}

- (void)invokeOnSuccess:(NSDictionary *)json  {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.taskOnSuccess) {
            self.taskOnSuccess(json);
        }
    });
}

- (void)invokeOnFailed:(NSDictionary *)json error:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.taskOnFailed) {
            self.taskOnFailed(json, error);
            NSLog(@"taskOnFailed:%@",json);
        }
    });
}

- (void)unauthorized {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kWS_InteriorNotification_User_NeedLogin object:nil userInfo:@{@"needAlert":@(YES)}];
    });
}

- (void)generateWorkerQueue {
    if (!gWorkerQueue) {
        gWorkerQueue = [[NSOperationQueue alloc] init];
        gWorkerQueue.maxConcurrentOperationCount = 1;
        gWorkerQueue.name = @"WS_Network";
    }
}

- (void)generateWorkerCommon {
    if (!gWorkerCommon) {
        gWorkerCommon = @{@"platform"    :@"",
                          @"version"     :[DeviceInformation getAppVersion],
                          @"osversion"   :[DeviceInformation getOSVersion],
                          @"uuid"        :[DeviceInformation getDeviceId],
                          @"model"       :[DeviceInformation getCurrentDeviceMode],
                          @"ip"          :[DeviceInformation getCurrentIp],
                          @"resolution"  :[DeviceInformation getResolution]
                          };
    }
}

- (void)generateWorkerSession {
    if (!gWorkerSession) {
        NSURLSessionConfiguration *config = [[NSURLSessionConfiguration ephemeralSessionConfiguration] copy];
        config.timeoutIntervalForRequest = 10;
        config.timeoutIntervalForResource = 10;
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.HTTPShouldSetCookies = NO;
        gWorkerSession = [NSURLSession sessionWithConfiguration:config];
    }
}

@end
