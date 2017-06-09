//
//  FMAlipaySDKResultJsonModel.h
//  FlashMan
//
//  Created by 小河 on 17/2/15.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FMAlipaySDKResultModel.h"
@interface FMAlipaySDKResultJsonModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*memo;
@property(nonatomic,strong)NSString <FMAlipaySDKResultModel,Optional>*result;
@property(nonatomic,strong)NSString <Optional>*resultStatus;
@end
