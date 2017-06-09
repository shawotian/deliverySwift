//
//  DPPaySucModel.h
//  DeliveryPerson
//
//  Created by dianda on 2016/11/22.
//  Copyright © 2016年 ctc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel.h>

@interface DPPaySucModel : JSONModel

@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString <Optional>*message;
@property (strong, nonatomic) NSString <Optional>*orderID;
@property (strong, nonatomic) NSString <Optional>*tradeNumber;
@property (strong, nonatomic) NSString <Optional>*tradeTime;
@property (strong, nonatomic) NSString <Optional>*storeName;
@property (strong, nonatomic) NSNumber <Optional>*sum;
@end
