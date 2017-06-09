//
//  FMCertainSendArrivedView.h
//  FlashMan
//
//  Created by 小河 on 17/1/20.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMCertainSendArrivedView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UILabel *typeTextLabrl;


@property (weak, nonatomic) IBOutlet UIView *cashBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *wechatBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *alipyBackgroundView;


//现金支付
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
//微信支付
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
//支付宝支付
@property (weak, nonatomic) IBOutlet UIButton *alipyBtn;


@end
