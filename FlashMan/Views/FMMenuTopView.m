//
//  FMMenuTopView.m
//  FlashMan
//
//  Created by taitanxiami on 2017/1/4.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMMenuTopView.h"

@implementation FMMenuTopView



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.contents = (__bridge id) [UIImage imageNamed:@"menu_bg"].CGImage;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.clipsToBounds  = YES;
    
    self.pigImageView.layer.cornerRadius = 3.0f;
    self.pigImageView.clipsToBounds = YES;
    
    self.rightBtn.hidden = YES;
}

@end
