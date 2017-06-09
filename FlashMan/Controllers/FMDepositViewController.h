//
//  FMDepositViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface FMDepositViewController : BaseViewController
@property(nonatomic,strong)NSNumber *depositMoney;
@property(nonatomic,strong)NSNumber <Optional>*frozenAmount;
@property(nonatomic,strong)NSNumber *balanceMoney;
@end
