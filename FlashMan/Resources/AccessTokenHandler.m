//
//  AccessTokenHandler.m
//  diandaStore
//
//  Created by taitanxiami on 16/7/14.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "AccessTokenHandler.h"
//#import "JMViewControllerManager.h"
#import "FMGuildViewController.h"
#import <SSKeychain.h>
#import "FMLoginViewController.h"
@implementation AccessTokenHandler

+ (void)refreshTokenWithTimes:(NSInteger)times  block:(BaseResultBlock)block {
    
    
    NSDictionary *paramas = nil;
    NSString *urls = [NSString stringWithFormat:@"%@/v1/salesman/login",SERVER_ADDRESS];
    if (!paramas) {
        NSString *phoneNum = [UserDefaultsUtils valueWithKey:kUserPhoneNum];
        if(phoneNum == nil) {
            return;
        }
        NSString *pwd = [SSKeychain passwordForService:kPassword account:kPassword];
        NSString *pwdMD5Str = [AppUtils md5FromString:pwd];
        paramas = @{@"salesmanPN":phoneNum, @"password":pwdMD5Str, @"platform":@"IOS", @"version":[AppUtils getAPPVersion]};
        
    }
    AFHTTPRequestOperation *opreration = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    opreration = [manager POST:urls parameters:paramas success:^(AFHTTPRequestOperation * _Nonnull operations, id  _Nonnull responseObject) {
        
            NSDictionary *loginDic = (NSDictionary *)responseObject;
            
            if(operations.response.statusCode == 401) {
                if (times > 0) {
                    NSInteger newTimes = times - 1;
                    [self refreshTokenWithTimes:newTimes  block:block];
                }else {
//                    [JMViewControllerManager presentQYController:JMViewControllerLogin];
                    
                    FMLoginViewController *vc = [[FMLoginViewController alloc]init];
                    FMGuildViewController *nav = [[FMGuildViewController alloc]init];
                    [nav prentViewController:vc];
                    
                }
                
            }else if(operations.response.statusCode == 200) {
                
                /**
                 *  返回成功后只保存token即可
                 */
                if ([loginDic[kSTATUS] integerValue] == 1) {
                    
                    [UserDefaultsUtils saveValue:loginDic[@"token"] forKey:kToken];
                    
                }else if ([loginDic[kSTATUS] integerValue] == -1 ) {
                    
                    UIViewController *login = [UIApplication sharedApplication].keyWindow.rootViewController;
                    if (![login isKindOfClass:[FMLoginViewController class]]) {
                        
                        [AccessTokenHandler clearToken];
                        [UserDefaultsUtils saveValue:nil forKey:kToken];
//                        [JMViewControllerManager presentQYController:JMViewControllerLogin];
                        FMLoginViewController *vc = [[FMLoginViewController alloc]init];
                        FMGuildViewController *nav = [[FMGuildViewController alloc]init];
                        [nav prentViewController:vc];

                    }
                    
                }
                //获取token成功后回调
                block(loginDic,nil);
            }else {
                
            }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operations, NSError * _Nonnull error) {
        
        if (block) {
            block(nil,error);
        }
        
    }];

}

+ (void)clearToken {
    
    [SSKeychain deletePasswordForService:kPassword account:kPassword];
        [UserDefaultsUtils saveValue:nil forKey:kUserPhoneNum];
        [UserDefaultsUtils saveValue:nil forKey:kToken];
        [UserDefaultsUtils saveValue:nil forKey:@"mid"];
}
@end
