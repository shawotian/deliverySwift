//
//  FMTransactionView.h
//  FlashMan
//
//  Created by 小河 on 17/1/14.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMTransactionView : UIView
//全部
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
//配送收入
@property (weak, nonatomic) IBOutlet UIButton *distributionInBtn;
//提现
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
//充值金
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
//押金转余额
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
//扣违约金
@property (weak, nonatomic) IBOutlet UIButton *deductionBtn;

@end
