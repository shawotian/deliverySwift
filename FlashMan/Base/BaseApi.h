//
//  BaseApi.h
//  diandaStore
//
//  Created by taitanxiami on 16/7/14.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^ BaseResultBlock)(id data, NSError *error);
typedef void (^ BaseRequestSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^ BaseRequestFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface BaseApi : AFHTTPSessionManager
+ (instancetype)loginTokenGrantInstance;
@end
