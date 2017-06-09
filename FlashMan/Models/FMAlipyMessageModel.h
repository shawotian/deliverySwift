//
//  FMAlipyMessageModel.h
//  FlashMan
//
//  Created by 小河 on 17/2/14.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol FMAlipyMessageModel @end

@interface FMAlipyMessageModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*accountId;
@property(nonatomic,strong)NSString <Optional>* accountNo;
@property(nonatomic,strong)NSString <Optional>*accountType;
@property(nonatomic,strong)NSNumber <Optional>*id;
@property(nonatomic,strong)NSString <Optional>*userName;
@end
