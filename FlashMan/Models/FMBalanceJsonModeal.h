//
//  FMBalanceJsonModeal.h
//  FlashMan
//
//  Created by 小河 on 17/1/13.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FMBalanceModel.h"

@interface FMBalanceJsonModeal : JSONModel

@property (nonatomic,strong) NSMutableArray <FMBalanceModel,Optional> *data;

@end
