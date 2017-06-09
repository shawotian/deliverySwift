//
//  FMMyWalletModel.h
//  FlashMan
//
//  Created by 小河 on 17/1/21.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMMyWalletModel : JSONModel

@property(nonatomic,strong)NSNumber <Optional>*balance;
@property(nonatomic,strong)NSNumber <Optional>*deposit;
@property(nonatomic,strong)NSNumber <Optional>*frozenAmount;
@property(nonatomic,strong)NSNumber <Optional>*usable;
@property(nonatomic,strong)NSNumber <Optional>*creditAmount;

@end
