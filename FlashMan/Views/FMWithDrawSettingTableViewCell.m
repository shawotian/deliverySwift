//
//  FMWithDrawSettingTableViewCell.m
//  FlashMan
//
//  Created by 小河 on 17/2/14.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMWithDrawSettingTableViewCell.h"

@implementation FMWithDrawSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}
-(void)setAlipyMessageModel:(FMAlipyMessageModel *)alipyMessageModel
{
    _alipyMessageModel = alipyMessageModel;
    self.alipyNumLabel.text = alipyMessageModel.accountNo;
}
// 复用id
+ (NSString *)identifier
{
    return @"FMWithDrawwSettingTableViewCellID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
