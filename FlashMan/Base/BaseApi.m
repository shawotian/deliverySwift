//
//  BaseApi.m
//  diandaStore
//
//  Created by taitanxiami on 16/7/14.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "BaseApi.h"
#import "AccessTokenHandler.h"
@implementation BaseApi

+ (instancetype)loginTokenGrantInstance {
    static BaseApi *_passwordGrantInstance = nil;
    static dispatch_once_t passwordGrantOnceToken;
    dispatch_once(&passwordGrantOnceToken, ^{
        _passwordGrantInstance = [[BaseApi alloc] initWithBaseURL:[NSURL URLWithString:SERVER_ADDRESS]];
        [_passwordGrantInstance prepareForCommonRequest];
    });
    
    NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
    [_passwordGrantInstance.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    return _passwordGrantInstance;
}

- (void)prepareForCommonRequest {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
//    [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 25.f;
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

#pragma mark - override  GET adn POST Method 

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                
                NSHTTPURLResponse *responsea = (NSHTTPURLResponse *)response;
                if(responsea.statusCode == 401) {
                    BaseResultBlock block = ^(NSDictionary *data,NSError *error) {
                        if (!error) {
                            [self POST:URLString parameters:parameters success:success failure:failure];
                            
                        }else {
                            if (error.code == NSURLErrorTimedOut) {
                            }
                        }
                    };
                    [AccessTokenHandler refreshTokenWithTimes:3 block:block];
                }else {
                    failure(task, error);
                }
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;

}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            NSHTTPURLResponse *responsea = (NSHTTPURLResponse *)response;
            if(responsea.statusCode == 401) {
                BaseResultBlock blocks = ^(NSDictionary *data,NSError *error) {
                    if (!error) {
                        [self POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
                        
                    }else {
                        if (error.code == NSURLErrorTimedOut) {
                        }
                    }
                };
                [AccessTokenHandler refreshTokenWithTimes:3 block:blocks];
            }else {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];

    
    return task;

}
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                
                NSHTTPURLResponse *responsea = (NSHTTPURLResponse *)response;
                if(responsea.statusCode == 401) {
                    BaseResultBlock block = ^(NSDictionary *data,NSError *error) {
                        if (!error) {
                           [self GET:URLString parameters:parameters success:success failure:failure];
                        }else {
                            if (error.code == NSURLErrorTimedOut) {
                            }
                        }
                    };
                    [AccessTokenHandler refreshTokenWithTimes:3 block:block];
                }else {
                    failure(task, error);
                }
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}
@end
