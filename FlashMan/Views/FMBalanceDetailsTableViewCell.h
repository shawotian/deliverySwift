//
//  FMBalanceDetailsTableViewCell.h
//  FlashMan
//
//  Created by 小河 on 17/1/12.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBalanceModel.h"
@interface FMBalanceDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailLabel;
@property(nonatomic,strong)FMBalanceModel *model;

// 复用id
+ (NSString *)identifier;

@end
