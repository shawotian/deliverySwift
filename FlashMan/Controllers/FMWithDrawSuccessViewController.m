//
//  FMWithDrawSuccessViewController.m
//  FlashMan
//
//  Created by 小河 on 17/2/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMWithDrawSuccessViewController.h"
#import "FMMyWalletViewController.h"
@interface FMWithDrawSuccessViewController ()

@end

@implementation FMWithDrawSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.whiteView.layer.cornerRadius = 3.0f;
    self.whiteView.clipsToBounds = YES;
    
    self.finishedBtn.layer.cornerRadius = 3.0f;
    self.finishedBtn.clipsToBounds = YES;
    
    [self.finishedBtn addTarget:self action:@selector(finishedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.withDrawMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.withDrawMoney doubleValue]];
    self.alipyNumLabel.text = [NSString stringWithFormat:@"%@",self.alipyNum];
    
}
-(void)finishedBtnClicked
{
    FMMyWalletViewController *vc = [[FMMyWalletViewController alloc]init];
    
    FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:vc animated:NO];
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
