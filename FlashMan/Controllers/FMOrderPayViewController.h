//
//  FMOrderPayViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, JMViewControllerPayType) {
    JMViewControllerPayTypeSubMit,
    JMViewControllerPayTypeRecharge,
    
};

@interface FMOrderPayViewController : BaseViewController
@property(nonatomic,strong)NSString *rechargeMoney;

@property(nonatomic,assign)JMViewControllerPayType controllType;

@property(nonatomic,strong)NSArray *idsArr;
@end
