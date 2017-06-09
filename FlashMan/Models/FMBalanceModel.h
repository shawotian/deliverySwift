//
//  FMBalanceModel.h
//  FlashMan
//
//  Created by 小河 on 17/1/13.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol FMBalanceModel @end

@interface FMBalanceModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *DeliveryManId;
@property (nonatomic,strong) NSNumber<Optional> *id;
@property (nonatomic,strong) NSString<Optional> *numberId;
@property (nonatomic,strong) NSString<Optional> *state;
@property (nonatomic,strong) NSString<Optional> *tradeNumberId;
@property (nonatomic,strong) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *createdAt;
@property (nonatomic,copy) NSString<Optional> *payMethod;
@property (nonatomic,copy) NSString<Optional> *transferAmount;
@property (nonatomic,copy) NSString<Optional> *typeState;
@property (nonatomic,copy) NSString<Optional> *updatedAt;

@end
