//
//  FMOrderDetailController.h
//  FlashMan
//
//  Created by dianda on 2017/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, JMViewControllerDetailType) {
    JMViewControllerToBeOrdersDetail,//可接单
    JMViewControllerToBePickedUpDetail,
    JMViewControllerDeliveryDetail,
    JMViewControllerReturningDetail,
    JMViewControllerFinishedDetail
};

@interface FMOrderDetailController : BaseTableViewController

@property (strong, nonatomic) NSNumber *orderID;
@property(nonatomic,assign)JMViewControllerDetailType controllType;
@end
