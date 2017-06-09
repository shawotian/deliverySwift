//
//  FMBalanceDescribeViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/21.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBalanceModel.h"
#import "BaseViewController.h"
@interface FMBalanceDescribeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *chuzhangMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunDanIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiaoyIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyLabel;

@property(nonatomic,strong)FMBalanceModel *model;
@property(nonatomic,strong)NSNumber *balanceId;


@end
