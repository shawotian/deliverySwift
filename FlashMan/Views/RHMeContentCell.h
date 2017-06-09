//
//  RHMeContentCell.h
//  dogBuy
//
//  Created by taitanxiami on 2016/10/24.
//  Copyright © 2016年 diandactc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHMeContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightTipsImageView;
@end
