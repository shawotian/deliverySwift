//
//  NetRequestClass.m
//
//  Created by taitanxiami on 15/1/6.
//  Copyright (c) 2015年 taitanxiami. All rights reserved.

#import "NetRequestClass.h"
#import <SSKeychain.h>
#import "UserDefaultsUtils.h"
#import "FMGuildViewController.h"
//#import "JMViewControllerManager.h"
#import "FMLoginViewController.h"
#import "AccessTokenHandler.h"
//#import "FMOrderDetailController.h"
@interface NetRequestClass ()

@end
@implementation NetRequestClass

#pragma 监测网络的可链接性
- (BOOL) netWorkReachabilityWithURLString:(NSString *)strUrl
{
    __block BOOL netState = NO;
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    return netState;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
- (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    
//    __weak __typeof(self)weakSelf = self;

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *op = [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[kTAG] isEqualToString:kSUCCESS]) {
            block(dic);
        }else if([dic[@"status"] integerValue]==401)
        {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow  addSubview:HUD];
            
            HUD.labelText = dic[@"message"];
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                
                [HUD removeFromSuperview];
                failureBlock();
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logOutSuccess" object:nil];
                //TOKEN 失效
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
                FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
                loginVC.type = FMLoginTypeLogin;
                REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [tabbarVc hideMenuViewController];
                [tabbarVc.childViewControllers[0] popToRootViewControllerAnimated:NO];
                
                [tabbarVc.childViewControllers[0] pushViewController:loginVC animated:YES];

            }];
            
        }
        else{
            
            errorBlock(dic);
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {


        if (operation.response.statusCode == 401) {
            //TOKEN 失效
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow  addSubview:HUD];
            
            HUD.labelText = @"请重新登录！";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                
                [HUD removeFromSuperview];
                failureBlock();
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logOutSuccess" object:nil];
                //TOKEN 失效
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
                FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
                loginVC.type = FMLoginTypeLogin;
                REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [tabbarVc hideMenuViewController];
                [tabbarVc.childViewControllers[0] popToRootViewControllerAnimated:NO];
                
                [tabbarVc.childViewControllers[0] pushViewController:loginVC animated:YES];
                
            }];

        }
        else
        {
            failureBlock();
            
        }
        
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op start];
    
}

#pragma --mark POST请求方式

- (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
//    __weak typeof(self)weakself = self;

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    NSString *token  = [SSKeychain passwordForService:kToken account:kToken];
    NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    AFHTTPRequestOperation *op = [manager POST:requestURLString
                                    parameters:parameter
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
            if ([dic[kTAG] isEqualToString:kSUCCESS]) {
                       
                   block(dic);
            }
            else if([dic[@"status"] integerValue]==401)
            {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
                [[UIApplication sharedApplication].keyWindow  addSubview:HUD];
                
                HUD.labelText = dic[@"message"];
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2.0);
                } completionBlock:^{
                    
                    [HUD removeFromSuperview];
                    failureBlock();
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logOutSuccess" object:nil];
                    //TOKEN 失效
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
                    FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    loginVC.type = FMLoginTypeLogin;
                    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [tabbarVc hideMenuViewController];
                    [tabbarVc.childViewControllers[0] popToRootViewControllerAnimated:NO];
                    
                    [tabbarVc.childViewControllers[0] pushViewController:loginVC animated:YES];
                    
                }];
                
            }
            else {
                errorBlock(dic);

            }
        /***************************************
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         ******************************/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 401) {
            
            //TOKEN 失效
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication].keyWindow  addSubview:HUD];
            
            HUD.labelText = @"请重新登录！";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2.0);
            } completionBlock:^{
                
                [HUD removeFromSuperview];
                failureBlock();
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logOutSuccess" object:nil];
                //TOKEN 失效
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
                FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
                loginVC.type = FMLoginTypeLogin;
                REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [tabbarVc hideMenuViewController];
                [tabbarVc.childViewControllers[0] popToRootViewControllerAnimated:NO];
                
                [tabbarVc.childViewControllers[0] pushViewController:loginVC animated:YES];
                
            }];

        }
        else
        {
            failureBlock();
            
        }
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];

}
/**
 *  获取token
 *
 *  @param paramas 存储用户手机号和密码（MD5加密）
 */
- (void)getTokenWithParamas:(NSDictionary *)paramas withTimes:(NSInteger)times returnBlack:(ReturnValueBlock)returnValueBlock {
    
//    __weak __typeof(self)weakSelf = self;
    NSString *urls = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kLOGIN];
    
    AFHTTPRequestOperation *opreration = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    opreration = [manager POST:urls parameters:paramas success:^(AFHTTPRequestOperation * _Nonnull operations, id  _Nonnull responseObject) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSDictionary *loginDic = (NSDictionary *)responseObject;
                NSDictionary *loginDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if(operations.response.statusCode == 401) {
                    //*******获取token失败*******
                    //如果失败，递归处理（最多请求3次）
                    if (times > 0) {
                        NSInteger newTimes = times - 1;
                        [self getTokenWithParamas:paramas withTimes:newTimes returnBlack:returnValueBlock];
                    }else {
                        
                        returnValueBlock(loginDic);
                    }
                    
                }else if(operations.response.statusCode == 200) {
                    
                    /**
                     *  返回成功后只保存token即可
                     */
                    //*******保存下来用户信息********
                    
                    if ([loginDic[kSTATUS] integerValue] == 1) {
                        
                        //保存token
                        NSDictionary *data = loginDic[@"data"];
                        [UserDefaultsUtils saveValue:data[@"token"] forKey:kToken];

                    }else if ([loginDic[kSTATUS] integerValue] == -1 ) {
                        
                     
                        REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                        
                        FMLoginViewController *vc = [[FMLoginViewController alloc]init];
                        [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];
                        
                        [AccessTokenHandler clearToken];

                    }
                    
                    //获取token成功后回调
                    returnValueBlock(loginDic);
                }else {
                    
                }
                
            });
        } failure:^(AFHTTPRequestOperation * _Nonnull operations, NSError * _Nonnull error) {
            
            
        }];


    opreration.responseSerializer = [AFHTTPResponseSerializer serializer];
    [opreration start];

}


@end
