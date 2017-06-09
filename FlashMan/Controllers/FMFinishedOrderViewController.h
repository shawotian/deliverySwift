//
//  FMFinishedOrderViewController.h
//  FlashMan
//
//  Created by 小河 on 17/1/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, JMViewControllerType) {
    JMViewControllerFinished,
    JMViewControllerCancelled
  
};
@interface FMFinishedOrderViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *finishedCount;

@property (weak, nonatomic) IBOutlet UILabel *cancelCount;
@property (weak, nonatomic) IBOutlet UILabel *profitNum;
@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouAddressLabel;

@property(nonatomic,assign)JMViewControllerType controllType;

@end
