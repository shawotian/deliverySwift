//
//  BaseTableViewController.m
//  FlashMan
//
//  Created by dianda on 2017/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 11, 20)];
    [leftbutton setImage:[UIImage imageNamed:@"nav_leftbutton_back"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(showback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
}


- (void)showback {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
