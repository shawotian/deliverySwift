//
//  FMQRCodePayTypeViewController.h
//  FlashMan
//
//  Created by 小河 on 17/3/21.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,SMViewControllerPayType) {
    
    SMViewControllerWeChatPay,
    SMViewControllerWeAlipyPay
    
};

@interface FMQRCodePayTypeViewController : UIViewController
//订单号
@property(nonatomic,strong)NSString *orderId;
//付款单号
@property(nonatomic,strong)NSNumber *payId;
//生成二维码的url
@property(nonatomic,strong)NSString *codeUrl;
//订单金额
@property(nonatomic,strong)NSString *moneyNum;

@property(nonatomic,assign)SMViewControllerPayType payType;

@end
