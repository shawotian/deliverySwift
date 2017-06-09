//
//  FMArrivedModel.h
//  FlashMan
//
//  Created by 小河 on 17/3/30.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMArrivedModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*codeUrl;
@property (strong, nonatomic) NSNumber <Optional>*payId;
@end
