//
//  FMTanKuangView.h
//  FlashMan
//
//  Created by 小河 on 17/2/8.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMTanKuangView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//继续提现
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
//押金充值
@property (weak, nonatomic) IBOutlet UIButton *depositBtn;

@end
