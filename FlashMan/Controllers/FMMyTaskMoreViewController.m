//
//  FMMyTaskMoreViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMMyTaskMoreViewController.h"
#import "FMFinishedOrderViewController.h"
#import "FMHomeViewController.h"
@interface FMMyTaskMoreViewController ()

@end

@implementation FMMyTaskMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.finishedView.layer.cornerRadius = 3.0f;
    self.finishedView.clipsToBounds = YES;
    
    self.cancelView.layer.cornerRadius = 3.0f;;
    self.cancelView.clipsToBounds = YES;
    
    [self.finishedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishedViewClick)]];
    [self.cancelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelViewClick)]];
    
}

-(void)finishedViewClick
{
    //已完成的订单
    FMFinishedOrderViewController  *vc = [[FMFinishedOrderViewController alloc]init];
    vc.controllType = JMViewControllerFinished;
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];
}
-(void)cancelViewClick
{
    //已取消的订单
    FMFinishedOrderViewController  *vc = [[FMFinishedOrderViewController alloc]init];
    vc.controllType = JMViewControllerCancelled;
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
