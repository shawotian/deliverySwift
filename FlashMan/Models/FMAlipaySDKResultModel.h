//
//  FMAlipaySDKResultModel.h
//  FlashMan
//
//  Created by 小河 on 17/2/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol FMAlipaySDKResultModel @end

@interface FMAlipaySDKResultModel : JSONModel

@property(nonatomic,strong)NSString <Optional>*alipay_trade_app_pay_response;
@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*msg;
@property(nonatomic,strong)NSString <Optional>*app_id;
@property(nonatomic,strong)NSString <Optional>*out_trade_no;
@property(nonatomic,strong)NSString <Optional>*trade_no;
@property(nonatomic,strong)NSString <Optional>*total_amount;
@property(nonatomic,strong)NSString <Optional>*seller_id;
@property(nonatomic,strong)NSString <Optional>*charset;
@property(nonatomic,strong)NSString <Optional>*timestamp;
@property(nonatomic,strong)NSString <Optional>*sign;
@property(nonatomic,strong)NSString <Optional>*sign_type;

@end
