//
//  FMContactMeController.h
//  FlashMan
//
//  Created by dianda on 2017/1/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "BaseTableViewController.h"

@interface FMContactMeController : BaseTableViewController
@property (strong, nonatomic) IBOutlet UITableView *tv;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;

@end
