//
//  FMOrderAddressCell.m
//  FlashMan
//
//  Created by dianda on 2017/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMOrderAddressCell.h"

@implementation FMOrderAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 2.0f;
    self.bgView.layer.masksToBounds = YES;
}


@end
