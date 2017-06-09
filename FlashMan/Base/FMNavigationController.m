//
//  FMNavigationController.m
//  FlashMan
//
//  Created by taitanxiami on 2017/1/4.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMNavigationController.h"
#import "FMMenuViewController.h"
#import "REFrostedViewController.h"
#import <UIViewController+REFrostedViewController.h>

@interface FMNavigationController ()

@property (strong, nonatomic) FMMenuViewController *menuController;

@end

@implementation FMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];

}


- (void)showMenu {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
    if (token == nil || [token isEqualToString:@""]) {
        [XHView showTipHud:@"请先登录" superView:self.view];

    }else {
        [self.frostedViewController presentMenuViewController];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
