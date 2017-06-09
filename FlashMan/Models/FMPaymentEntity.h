//
//  FMPaymentEntity.h
//  FlashMan
//
//  Created by dianda on 2017/1/20.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMPaymentEntity : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSNumber <Optional>*DeliveryOrderId;
@property (strong, nonatomic) NSString <Optional>*numberId;

//订单金额
@property (strong, nonatomic) NSNumber <Optional>*orderAmount;

@property (strong, nonatomic) NSNumber <Optional>*state;

//是否选中
@property (strong, nonatomic) NSNumber <Optional>*isSelect;
@end
