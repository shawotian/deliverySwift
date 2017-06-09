//
//  FMAlipyMessageJsonModel.h
//  FlashMan
//
//  Created by 小河 on 17/2/14.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FMAlipyMessageModel.h"
@interface FMAlipyMessageJsonModel : JSONModel
@property(nonatomic,strong)NSMutableArray <FMAlipyMessageModel, Optional >*data;
@end
