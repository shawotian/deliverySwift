//
//  FMDepositRechargeViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMDepositRechargeViewController.h"
#import "FMOrderPayViewController.h"
#import "FMMyWalletViewController.h"
@interface FMDepositRechargeViewController ()

//余额支付
@property(nonatomic,strong)UIButton *leftMoneyPayBtn;
//其他支付方式
@property(nonatomic,strong)UIButton *otherPayBtn;
//支付方式
@property(nonatomic,strong)NSString *payTypeStr;

@end

@implementation FMDepositRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kFMLGraryColor;
    self.title = @"选择支付方式";
    
    _payTypeStr = @"balance";
    [self addSubViews];
}
//余额转入
-(void)balancePayData{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kBALANCEPAY];
    NSString *sumStr = [NSString stringWithFormat:@"%.2f",[self.rechargeMoney doubleValue]];
    NSDictionary *dict = @{
                           @"sum":sumStr,
                               @"type":_payTypeStr
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        [self paySuccess];
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        [XHView showTipHud:@"余额支付失败" superView:self.view];

    }];

}
-(void)paySuccess
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"支付结果"
                                                                   message:@"余额支付成功！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          FMMyWalletViewController *vc = [[FMMyWalletViewController alloc]init];
                                                          
                                                          FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
                                                          [nav popToRootViewControllerAnimated:NO];
                                                          [nav pushViewController:vc animated:NO];
                                                      }];
    
    [alert addAction:delAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark - 搭建页面
-(void)addSubViews
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    //
    UILabel *moneyLabel = [XHView createLabelWithFrame:CGRectMake(0, 25, ScreenWidth, 30) text:[NSString stringWithFormat:@"%.2f",[self.rechargeMoney doubleValue]] textColor:kFMBlueColor font:[UIFont systemFontOfSize:20.0f] superView:headerView];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    //充值金额
    UILabel *moneyTextLabel = [XHView createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(moneyLabel.frame), ScreenWidth, 20) text:@"充值金额" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0f] superView:headerView];
    moneyTextLabel.textAlignment = NSTextAlignmentCenter;
    
    //请选择支付方式
    UILabel *payTypeLabel = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame), ScreenWidth, 35) text:@"请选择支付方式" textColor:kFMWordGrayColor font:[UIFont systemFontOfSize:14.0f] superView:headerView];
    
    //
    UIView *payTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payTypeLabel.frame), ScreenWidth, 90)];
    payTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payTypeView];

    //余额支付
    UILabel *leftMoneyLabel = [XHView createLabelWithFrame:CGRectMake(10, 0, ScreenWidth/2, 25) text:@"余额支付（推荐）" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0f] superView:payTypeView];
    
    double cha = [self.balanceMoney doubleValue] - [self.rechargeMoney doubleValue];
    
    UILabel *leftMoneyDetail = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(leftMoneyLabel.frame), ScreenWidth/2+40, 20) text:@"（当前可用余额：）" textColor:[UIColor redColor] font:k12SizeFont superView:payTypeView];
    if (cha>=0) {
        leftMoneyDetail.text = [NSString stringWithFormat:@"当前可用余额：%.2f元",[self.balanceMoney doubleValue]];
    }
    else
    {
        leftMoneyDetail.text = [NSString stringWithFormat:@"当前可用余额：%.2f元，不足",[self.balanceMoney doubleValue]];
    }
    
    UIButton *leftMoneyPayBtn = [XHView createBtnWithFrame:CGRectMake(ScreenWidth-55, 0, 45, 45) text:nil textColor:nil backgroundColor:nil setImgName:@"content_button_zhifuxuanze_normal" target:self action:@selector(leftMoneyPayBtnClicked) superView:payTypeView];
    [leftMoneyPayBtn setImage:[UIImage imageNamed:@"content_button_zhifuxuanze_pressed"] forState:UIControlStateSelected];
    leftMoneyPayBtn.selected = YES;
    _leftMoneyPayBtn = leftMoneyPayBtn;

    
    //line
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(leftMoneyDetail.frame), ScreenWidth, 0.5)];
    lineView.backgroundColor = kFMLLineGraryColor;
    [payTypeView addSubview:lineView];
    
    //其它支付方式
    UILabel *otherPayLabel = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame), ScreenWidth/2, 25) text:@"其他支付方式" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0f] superView:payTypeView];
    UILabel *otherPayDetail = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(otherPayLabel.frame), ScreenWidth/2, 20) text:@"如支付宝、微信支付等" textColor:kFMWordGrayColor font:k12SizeFont superView:payTypeView];
    
    UIButton *otherPayBtn = [XHView createBtnWithFrame:CGRectMake(ScreenWidth-55, CGRectGetMaxY(lineView.frame), 45, 45) text:nil textColor:nil backgroundColor:nil setImgName:@"content_button_zhifuxuanze_normal" target:self action:@selector(otherPayBtnClicked) superView:payTypeView];
    [otherPayBtn setImage:[UIImage imageNamed:@"content_button_zhifuxuanze_pressed"] forState:UIControlStateSelected];
    otherPayBtn.selected = NO;
    _otherPayBtn = otherPayBtn;
    
    //确认支付
    UIButton *certainBtn = [XHView createBtnWithFrame:CGRectMake(10, CGRectGetMaxY(payTypeView.frame)+30, ScreenWidth-20, 45) text:@"确认支付" textColor:[UIColor whiteColor] backgroundColor:kFMBlueColor setImgName:nil target:self action:@selector(certainBtnClicked) superView:self.view];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    certainBtn.layer.cornerRadius = 3.0f;
    certainBtn.clipsToBounds = YES;

}

#pragma mark - 响应事件
//余额支付
-(void)leftMoneyPayBtnClicked{
    
    _leftMoneyPayBtn.selected = YES;
    _otherPayBtn.selected = NO;
    _payTypeStr = @"balance";
    
}
//其他支付方式支付
-(void)otherPayBtnClicked{
    
    _leftMoneyPayBtn.selected = NO;
    _otherPayBtn.selected = YES;
    _payTypeStr = @"";
    
   
}
//确认支付
-(void)certainBtnClicked
{
    if (_leftMoneyPayBtn.selected) {
        double cha = [self.balanceMoney doubleValue] - [self.rechargeMoney doubleValue];
        if(cha>=0)
        {
            //余额支付
            [self balancePayData];
        }
        else
        {
            [XHView showTipHud:@"余额不足" superView:self.view];
        }
        
    }
    else
    {
        //其他支付方式
        FMOrderPayViewController *vc = [[FMOrderPayViewController alloc]init];
        vc.rechargeMoney = self.rechargeMoney;
        vc.controllType = JMViewControllerPayTypeRecharge;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
