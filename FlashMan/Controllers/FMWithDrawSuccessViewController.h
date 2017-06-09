//
//  FMWithDrawSuccessViewController.h
//  FlashMan
//
//  Created by 小河 on 17/2/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface FMWithDrawSuccessViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *withDrawMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
//提现金额
@property(nonatomic,strong)NSString *withDrawMoney;
@property (weak, nonatomic) IBOutlet UILabel *alipyNumLabel;
@property(nonatomic,strong)NSString *alipyNum;
@end
