//
//  FMMyTaskPageViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, JMViewControllerType) {
    JMViewControllerToBePickedUp,
    JMViewControllerDelivery,
    JMViewControllerReturning,
    JMViewControllerMore
};
@interface FMMyTaskPageViewController : BaseViewController

@property(nonatomic,assign)JMViewControllerType controllType;

@end
