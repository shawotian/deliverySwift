//
//  FMApplicationWithdrawViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JKCountDownButton.h>
#import "FMAlipyMessageModel.h"
#import "BaseViewController.h"
@interface FMApplicationWithdrawViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *currentBalanceLabel;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UITextField *checkTF;
@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;
@property (weak, nonatomic) IBOutlet JKCountDownButton *checkBtn;
@property(nonatomic,strong)NSNumber *leftMoney;
//支付宝账号
//@property(nonatomic,strong)NSString *alipayNumber;
@property(nonatomic,strong)FMAlipyMessageModel *model ;
@end
