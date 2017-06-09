//
//  FMFresszeMoneyEntity.h
//  FlashMan
//
//  Created by dianda on 2017/1/20.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMFresszeMoneyEntity : JSONModel


@property (strong, nonatomic) NSString <Optional>*state;

@property (strong, nonatomic) NSString <Optional>*finishSate;
@property (strong, nonatomic) NSNumber <Optional> * id;
//运单订单编号
@property (strong, nonatomic) NSString <Optional>*numberId;
@property (strong, nonatomic) NSString <Optional>*updatedAt;
@property (strong,nonatomic)NSNumber <Optional>* orderAmount;
@end
