//
//  FMWechatParameterModel.h
//  FlashMan
//
//  Created by 小河 on 17/2/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMWechatParameterModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*partnerid;
@property (strong, nonatomic) NSString <Optional>*prepayid;
@property (strong, nonatomic) NSString <Optional>*package;
@property (strong, nonatomic) NSString <Optional>*noncestr;
@property (strong, nonatomic) NSString <Optional>*timestamp;
@property (strong, nonatomic) NSString <Optional>*sign;
@end
