//
//  FMWithDrawSettingViewController.h
//  FlashMan
//
//  Created by 小河 on 17/2/14.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, JMViewControllerAlipyType) {
    JMViewControllerAlipyTypeSetting,//提现设置
    JMViewControllerAlipyTypeRecharge,//余额提现
    
};

@interface FMWithDrawSettingViewController : BaseViewController
@property(nonatomic,assign)JMViewControllerAlipyType controllType;
//余额
@property(nonatomic,strong)NSNumber *balaceMoney;
@end
