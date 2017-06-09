//
//  FMWithDrawSettingTC.m
//  FlashMan
//
//  Created by 小河 on 17/2/22.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMWithDrawSettingTC.h"

@implementation FMWithDrawSettingTC


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
    return @"FMWithDrawSettingTCID";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
