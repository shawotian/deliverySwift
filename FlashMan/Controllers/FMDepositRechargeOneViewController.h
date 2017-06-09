//
//  FMDepositRechargeOneViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface FMDepositRechargeOneViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStypeBtn;
@property(nonatomic,strong)NSNumber *balanceMoney;

@end
