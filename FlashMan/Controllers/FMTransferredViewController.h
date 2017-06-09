//
//  FMTransferredViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface FMTransferredViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *editMoneyTF;
@property (weak, nonatomic) IBOutlet UILabel *depositMoneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property(nonatomic,strong)NSNumber *depositMoney;
@property (weak, nonatomic) IBOutlet UIButton *transferredStateBtn;

@end
