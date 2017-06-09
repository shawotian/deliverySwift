//
//  FMArrivePaySuccessModel.h
//  FlashMan
//
//  Created by 小河 on 17/3/31.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMArrivePaySuccessModel : JSONModel

@property(nonatomic,strong)NSNumber <Optional>*hasPay;
@property(nonatomic,strong)NSNumber <Optional>*orderId;
@property(nonatomic,strong)NSString <Optional>*tradeRecordNo;
@property(nonatomic,strong)NSNumber <Optional>*orderAmount;
@property(nonatomic,strong)NSString <Optional>*time;


@end
