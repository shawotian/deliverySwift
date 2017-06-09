//
//  FMBalanceViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface FMBalanceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *balanceDetailsBtn;
@property (weak, nonatomic) IBOutlet UIButton *applicationWithdrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawHistoryBtn;
//余额
@property(nonatomic,strong)NSNumber *balaceMoney;
//押金
@property(nonatomic,strong)NSNumber *depositMoney;
@property (weak, nonatomic) IBOutlet UILabel *balanceMoneyLabel;

@end
