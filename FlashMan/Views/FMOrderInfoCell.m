//
//  FMOrderInfoCell.m
//  FlashMan
//
//  Created by dianda on 2017/1/12.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMOrderInfoCell.h"

@implementation FMOrderInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 3.0f;
    self.bgView.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
