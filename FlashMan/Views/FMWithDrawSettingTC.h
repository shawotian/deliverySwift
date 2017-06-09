//
//  FMWithDrawSettingTC.h
//  FlashMan
//
//  Created by 小河 on 17/2/22.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAlipyMessageModel.h"
@interface FMWithDrawSettingTC : UITableViewCell
// 复用id
+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
//支付宝账号
@property (weak, nonatomic) IBOutlet UILabel *alipyNumLabel;
//添加提现账号
@property (weak, nonatomic) IBOutlet UILabel *addWithDrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *alipyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alipyImage;
@property(nonatomic,strong)FMAlipyMessageModel *alipyMessageModel;
@end
