//
//  FMOrderListJsonModel.h
//  FlashMan
//
//  Created by 小河 on 17/1/18.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FMOrderModel.h"

@interface FMOrderListJsonModel : JSONModel
@property (nonatomic,strong) NSMutableArray <FMOrderModel,Optional> *data;

//已完成订单
@property (nonatomic,strong) NSNumber <Optional>*count;
@property (nonatomic,strong) NSNumber <Optional>*allOrderCount;
@property (nonatomic,strong) NSNumber <Optional>*todayOrderCount;
@property (nonatomic,strong) NSMutableArray <FMOrderModel,Optional> *list;
@end
