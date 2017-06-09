//
//  AppDelegate.m
//  FlashMan
//
//  Created by taitanxiami on 2017/1/4.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "AppDelegate.h"
#import "FMNavigationController.h"
#import "FMHomeViewController.h"
#import "FMMenuViewController.h"
#import "REFrostedViewController.h"
#import <UIViewController+REFrostedViewController.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "FMAlipaySDKResultJsonModel.h"
#import "FMAlipaySDKResultModel.h"
#import "FMLoginViewController.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    FMNavigationController *navigationController = [[FMNavigationController alloc] initWithRootViewController:[[FMHomeViewController alloc] init]];
    FMMenuViewController *menuController = [[FMMenuViewController alloc] init];
    
    // Create frosted view controller
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
//    frostedViewController.liveBlur = YES;
    frostedViewController.panGestureEnabled = NO;
//    frostedViewController.delegate = self;
    frostedViewController.menuViewSize = CGSizeMake(270, ScreenHeight);

    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self customUI];
    [self.window makeKeyAndVisible];
    
    //集成统计信息
    [Fabric with:@[[Crashlytics class]]];
    
    //向微信注册
    [WXApi registerApp:@"wx7ae5d54b23231e65" withDescription:@"FlashMan"];
    

    return YES;
    
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    
//    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            NSError *error = nil;
//            FMAlipaySDKResultJsonModel *jsonModel= [[FMAlipaySDKResultJsonModel alloc]initWithDictionary:resultDic error:&error];
            
            NSNumber *resultStatus = resultDic[@"resultStatus"];
            switch ([resultStatus integerValue]) {
                case 9000:
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                    
                    break;
                    
                default:
                    //发送失败的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFaile" object:resultStatus];
                    break;
            }

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

// NOTE: 9.0以后使用新API接口
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSError *error = nil;
//            FMAlipaySDKResultJsonModel *jsonModel= [[FMAlipaySDKResultJsonModel alloc]initWithDictionary:resultDic error:&error];

            NSNumber *resultStatus = resultDic[@"resultStatus"];
            switch ([resultStatus integerValue]) {
                case 9000:
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                    
                    break;
                    
                default:
                    //发送失败的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFaile" object:resultStatus];
                    break;
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {

            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)customUI {
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:kFMBlueColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
