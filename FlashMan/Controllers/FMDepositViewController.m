//
//  FMDepositViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMDepositViewController.h"
//#import "FMDepositRechargeViewController.h"
//转入余额
#import "FMTransferredViewController.h"
#import "FMDepositRechargeOneViewController.h"

#import "FMFreezeMoneyController.h"

@interface FMDepositViewController ()

@end

@implementation FMDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"押金";
    self.view.backgroundColor = kFMLGraryColor;

    [self addSubViews];
}

#pragma mark - 搭建界面
-(void)addSubViews
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    //押金text
    UILabel *depositTextLabel = [XHView createLabelWithFrame:CGRectMake(10, 10, 30, 25) text:@"押金" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0f] superView:headerView];
    //押金money
    UILabel *depositMoneyLabel = [XHView createLabelWithFrame:CGRectMake(CGRectGetMaxX(depositTextLabel.frame)+10, 10, 80, 25) text:[NSString stringWithFormat:@"%.2f",[self.depositMoney doubleValue]] textColor:kFMBlueColor font:[UIFont systemFontOfSize:16.0f] superView:headerView];
//    //冻结中freeze
//    UILabel *freezeLabel = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(depositTextLabel.frame), ScreenWidth-20, 35) text:[NSString stringWithFormat:@"(冻结中：%.2f元)",[self.frozenAmount doubleValue]] textColor:kFMWordGrayColor font:[UIFont systemFontOfSize:14.0f] superView:headerView];
//    //冻结明细button
//    UIButton *freezeBtn = [XHView createBtnWithFrame:CGRectMake(ScreenWidth-100, 12, 100, 45) text:@"冻结明细" textColor:kFMRedColor backgroundColor:[UIColor whiteColor] setImgName:@"menu_rightbutton_small" target:self action:@selector(freezeBtnClicked) superView:headerView];
//    freezeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    freezeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, -60);
//    freezeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    //押金充值
    UIButton *depositRechargeBtn = [XHView createBtnWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame)+20, ScreenWidth-20, 45) text:@"押金充值" textColor:[UIColor whiteColor] backgroundColor:kFMBlueColor setImgName:nil target:self action:@selector(depositBtnClicked) superView:self.view];
    depositRechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    depositRechargeBtn.layer.cornerRadius = 3.0f;
    depositRechargeBtn.clipsToBounds = YES;
    
    //转入余额
    UIButton *transferredBtn = [XHView createBtnWithFrame:CGRectMake(10, CGRectGetMaxY(depositRechargeBtn.frame)+10, ScreenWidth-20, 45) text:@"转入余额" textColor:[UIColor blackColor] backgroundColor:kFMWhiteColor setImgName:nil target:self action:@selector(transferredBtnClicked) superView:self.view];
    transferredBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    transferredBtn.layer.cornerRadius = 3.0f;
    transferredBtn.clipsToBounds = YES;

    
}


#pragma mark - 响应事件
//冻结明细按钮被点击
-(void)freezeBtnClicked
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMFreezeMoneyController" bundle:nil];
        FMFreezeMoneyController *fresszeMoney = [sb instantiateViewControllerWithIdentifier:@"FMFreezeMoneyController"];
    [self.navigationController pushViewController:fresszeMoney animated:YES];

    
}
//押金充值按钮被点击
-(void)depositBtnClicked
{
    FMDepositRechargeOneViewController *vc = [[FMDepositRechargeOneViewController alloc]init];
    vc.balanceMoney = self.balanceMoney;
    [self.navigationController pushViewController:vc animated:YES];

}
//转入余额按钮被点击
-(void)transferredBtnClicked
{
    FMTransferredViewController *vc = [[FMTransferredViewController alloc]init];
  
    double activityDeposit = [self.depositMoney doubleValue]-[self.frozenAmount doubleValue];
    
    vc.depositMoney = [NSNumber numberWithDouble:activityDeposit];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
