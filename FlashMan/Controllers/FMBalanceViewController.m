//
//  FMBalanceViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMBalanceViewController.h"
#import "FMBalanceDetailsViewController.h"
#import "FMApplicationWithdrawViewController.h"
#import "FMTanKuangView.h"
#import "FMSettingAlipayViewController.h"
#import "FMApplicationWithdrawViewController.h"
#import "FMWithDrawSettingViewController.h"
#import "FMApplicationWithdrawViewController.h"
#import "FMAlipyMessageJsonModel.h"
@interface FMBalanceViewController ()

@property(nonatomic,strong)UIView *viewLayer;
@property(nonatomic,strong)FMAlipyMessageJsonModel *alipyMessageJsonModel;

@end

@implementation FMBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额";
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-100, 20, 75, NavigationBarH-20)];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:@"提现设置" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(withdrawSettingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    UIBarButtonItem *itemBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=itemBtn;

    
    self.balanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.balaceMoney doubleValue]];
    self.balanceDetailsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, -60);
    
    self.applicationWithdrawBtn.clipsToBounds = YES;
    self.applicationWithdrawBtn.layer.cornerRadius = 3.0f;
    
    self.withdrawHistoryBtn.layer.cornerRadius = 3.0f;
    self.withdrawHistoryBtn.clipsToBounds = YES;
    
    //余额明细
    [self.balanceDetailsBtn addTarget:self action:@selector(balanceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //申请提现
    [self.applicationWithdrawBtn addTarget:self action:@selector(applicationWithdrawBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //提现历史
    [self.withdrawHistoryBtn addTarget:self action:@selector(withdrawHistoryBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}
//余额明细
-(void)balanceBtnClicked
{
    FMBalanceDetailsViewController *vc = [[FMBalanceDetailsViewController alloc]init];
    vc.controllType = JMViewControllerBalance;
    [self.navigationController pushViewController:vc animated:YES];
}
//申请提现
-(void)applicationWithdrawBtnClicked
{
    if([self.depositMoney doubleValue]<100)
    {
        //弹框显示
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.layer.contents = (__bridge id) [UIImage imageNamed:@"fdbeij"].CGImage;
        view.layer.contentsScale = [UIScreen mainScreen].scale;
        [self.view addSubview:view];
        _viewLayer = view;
        [[UIApplication sharedApplication].keyWindow addSubview:_viewLayer];
        
        //谈框
        FMTanKuangView * stateView = [[[NSBundle mainBundle] loadNibNamed:@"FMTanKuangView" owner:self options:nil] lastObject];
        stateView.frame = CGRectMake(40, (ScreenHeight-200)/2, ScreenWidth-80, 200);
        stateView.backgroundColor = [UIColor whiteColor];
        stateView.clipsToBounds = YES;
        stateView.layer.cornerRadius = 3.0f;
        [stateView.withdrawBtn addTarget:self action:@selector(withdrawBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [stateView.depositBtn addTarget:self action:@selector(depositBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewLayer addSubview:stateView];
        
        
    }
    else
    {
//        FMApplicationWithdrawViewController *vc = [[FMApplicationWithdrawViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
        //判断该手机号是否绑定支付宝账号
//        [self judgeIsHaveAlipayNumber];
//        FMWithDrawSettingViewController *vc = [[FMWithDrawSettingViewController alloc]init];
//        vc.balaceMoney = self.balaceMoney;
//        vc.controllType = JMViewControllerAlipyTypeRecharge;
//        [self.navigationController pushViewController:vc animated:YES];
        [self judgeIsHaveAlipayNumber];
        
        
    }
    
    
    
}
//判断当前手机号有没有绑定支付宝账号
-(void)judgeIsHaveAlipayNumber
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kCHECKPHONEALIPAY];
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        NSError *error = nil;
        FMAlipyMessageJsonModel *jsonModel= [[FMAlipyMessageJsonModel alloc]initWithDictionary:returnValue error:&error];
        self.alipyMessageJsonModel = jsonModel;
        if (jsonModel.data.count>0) {
            //如果当前手机号绑定了支付宝
            //提现
            FMApplicationWithdrawViewController *vc = [[FMApplicationWithdrawViewController alloc]init];
            FMAlipyMessageModel *model = self.alipyMessageJsonModel.data.firstObject;
            vc.leftMoney = self.balaceMoney;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            FMWithDrawSettingViewController *vc = [[FMWithDrawSettingViewController alloc]init];
            vc.controllType = JMViewControllerAlipyTypeRecharge;
            [self.navigationController pushViewController:vc animated:YES];        }
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        //        [self settingAlipayTanKuang];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        //        [self settingAlipayTanKuang];
    }];
    
}

//设置支付宝账号的弹框
-(void)settingAlipayTanKuang
{
    //弹框显示
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.layer.contents = (__bridge id) [UIImage imageNamed:@"fdbeij"].CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:view];
    _viewLayer = view;
    [[UIApplication sharedApplication].keyWindow addSubview:_viewLayer];
    
    //谈框
    FMTanKuangView * stateView = [[[NSBundle mainBundle] loadNibNamed:@"FMTanKuangView" owner:self options:nil] lastObject];
    stateView.frame = CGRectMake(40, (ScreenHeight-200)/2, ScreenWidth-80, 200);
    stateView.backgroundColor = [UIColor whiteColor];
    stateView.clipsToBounds = YES;
    stateView.layer.cornerRadius = 3.0f;
    stateView.titleLabel.text = @"未设置提现账号";
    stateView.contentLabel.text = @"你需要设置提现账号才能申请提现，提现账号可以为支付宝账号（推荐）";
    [stateView.withdrawBtn setTitle:@"暂不设置" forState:UIControlStateNormal] ;
    [stateView.depositBtn setTitle:@"现在设置" forState:UIControlStateNormal];
    [stateView.withdrawBtn addTarget:self action:@selector(notSettingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [stateView.depositBtn addTarget:self action:@selector(nowSettingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewLayer addSubview:stateView];

}
//判断提现账号
-(void)withdrawBtnClicked
{
    [_viewLayer removeFromSuperview];

    [self judgeIsHaveAlipayNumber];

    
}
//充值押金
-(void)depositBtnClicked
{
    [_viewLayer removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//现在设置
-(void)nowSettingBtnClicked
{
    [_viewLayer removeFromSuperview];
    //设置支付宝账号
    FMSettingAlipayViewController *vc = [[FMSettingAlipayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//暂不设置
-(void)notSettingBtnClicked
{
    [_viewLayer removeFromSuperview];
}
-(void)withdrawHistoryBtnClicked {
    
    FMBalanceDetailsViewController *vc = [[FMBalanceDetailsViewController alloc]init];
    vc.controllType = JMViewControllerWithdrawHistory;
    [self.navigationController pushViewController:vc animated:YES];
}
//提现设置
-(void)withdrawSettingBtnClicked
{
    FMWithDrawSettingViewController *vc = [[FMWithDrawSettingViewController alloc]init];
    vc.controllType = JMViewControllerAlipyTypeSetting;
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
