//
//  FMLoginViewController.h
//  FlashMan
//
//  Created by dianda on 2017/1/5.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, FMLoginType) {
    FMLoginTypeLogin,
    FMLoginTypeRegister
};
@interface FMLoginViewController : BaseTableViewController

@property (assign, nonatomic) FMLoginType type;
@property (weak, nonatomic) IBOutlet UIButton *registeredBtn;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (strong, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UILabel *xieyiLabel;

@end
