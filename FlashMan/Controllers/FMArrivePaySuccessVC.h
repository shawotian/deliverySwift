//
//  FMArrivePaySuccessVC.h
//  FlashMan
//
//  Created by 小河 on 17/3/31.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMArrivePaySuccessModel.h"
typedef NS_ENUM(NSUInteger,SMViewControllerPaySuccessType) {
    
    SMViewControllerSuccessWeChatPay,
    SMViewControllerSuccessWeAlipyPay
    
};
@interface FMArrivePaySuccessVC : UIViewController

@property(nonatomic,strong)FMArrivePaySuccessModel *successModel;

@property(nonatomic,assign)SMViewControllerPaySuccessType payType;

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
//交易单号
@property (weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;
//交易时间
@property (weak, nonatomic) IBOutlet UILabel *tradeDateLabel;
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic) NSString *orderID;

@end
