//
//  FMBalanceDetailsTableViewCell.m
//  FlashMan
//
//  Created by 小河 on 17/1/12.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMBalanceDetailsTableViewCell.h"

@implementation FMBalanceDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setModel:(FMBalanceModel *)model
{
    self.titleLabel.text = model.typeState;
    self.dateLabel.text = model.createdAt;
    self.moneyDetailLabel.text = model.transferAmount;
    
}
// 复用id
+ (NSString *)identifier
{
    return @"FMBalanceDetailsTableViewCellID";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
