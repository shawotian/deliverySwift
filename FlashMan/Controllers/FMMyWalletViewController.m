//
//  FMMyWalletViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMMyWalletViewController.h"
#import "FMBalanceViewController.h"
#import "FMDepositViewController.h"
#import "FMMyWalletModel.h"
#import "FMFreezeMoneyController.h"
@interface FMMyWalletViewController ()

//余额
@property(nonatomic,strong)UILabel *balanceLabel;
//押金
@property(nonatomic,strong)UILabel *depositLabel;
//授信额度
@property(nonatomic,strong)UILabel *lineOfCreditLabel;
//可接货额度
@property(nonatomic,strong)UILabel *canGetMoneyLabel;

@property(nonatomic,strong)FMMyWalletModel *model;

@end

@implementation FMMyWalletViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    self.view.backgroundColor = kFMLGraryColor;
    // Do any additional setup after loading the view.
    [self addSubViews];
}

#pragma mark - 搭建界面
-(void)addSubViews
{
    //左边whiteview
    UIView *leftWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2-1, 120)];
    leftWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftWhiteView];
    
    //右边whiteview
    UIView *rightWhiteView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftWhiteView.frame)+1, 0, ScreenWidth/2, 120)];
    rightWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightWhiteView];
    
    //余额
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth/2-1, 30)];
    balanceLabel.text = @"元";
    balanceLabel.textColor = kFMBlueColor;
    balanceLabel.font = [UIFont systemFontOfSize:12.0f];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [leftWhiteView addSubview:balanceLabel];
    _balanceLabel = balanceLabel;
    
    //余额text
    UILabel *balanceTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(balanceLabel.frame), ScreenWidth/4-10, 50)];
    balanceTextLabel.text = @"余额";
    balanceTextLabel.textAlignment = NSTextAlignmentRight;
    balanceTextLabel.font = [UIFont systemFontOfSize:14.0f];
    [leftWhiteView addSubview:balanceTextLabel];
    
    //明细及提现
    UIButton *detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(balanceTextLabel.frame), CGRectGetMaxY(balanceLabel.frame), 70, 50)];
//    detailBtn.backgroundColor = [UIColor blueColor];
    [detailBtn setTitle:@"明细及提现" forState:UIControlStateNormal];
    [detailBtn setTitleColor:kFMRedColor forState:UIControlStateNormal];
    detailBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [detailBtn addTarget:self action:@selector(detailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [leftWhiteView addSubview:detailBtn];
    
    
    //押金
    UILabel *depositLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth/2-1, 30)];
    depositLabel.text = @"元";
    depositLabel.font = [UIFont systemFontOfSize:12.0f];
    depositLabel.textColor = kFMBlueColor;
    depositLabel.textAlignment = NSTextAlignmentCenter;
    [rightWhiteView addSubview:depositLabel];
    _depositLabel = depositLabel;
    
    //押金text
    UILabel *depositTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(balanceLabel.frame), ScreenWidth/4, 50)];
    depositTextLabel.text = @"押金";
    depositTextLabel.textAlignment = NSTextAlignmentRight;
    depositTextLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightWhiteView addSubview:depositTextLabel];
    
    //查看
    UIButton *watchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(balanceTextLabel.frame), CGRectGetMaxY(balanceLabel.frame), 60, 50)];
    //    detailBtn.backgroundColor = [UIColor blueColor];
    [watchBtn setTitle:@"查看" forState:UIControlStateNormal];
    [watchBtn setTitleColor:kFMRedColor forState:UIControlStateNormal];
    watchBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [watchBtn addTarget:self action:@selector(watchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    watchBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [rightWhiteView addSubview:watchBtn];
    
//    ------------------------------------------------------
    //左边whiteview
    UIView *btleftWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(leftWhiteView.frame)+1, ScreenWidth/2-1, 120)];
    btleftWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btleftWhiteView];
    
    //右边whiteview
    UIView *btrightWhiteView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btleftWhiteView.frame)+1, CGRectGetMaxY(leftWhiteView.frame)+1, ScreenWidth/2, 120)];
    btrightWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btrightWhiteView];
    
    //授信额度
    UILabel *lineOfCreditLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth/2-1, 30)];
    lineOfCreditLabel.text = @"元";
    lineOfCreditLabel.textColor = kFMBlueColor;
    lineOfCreditLabel.font = [UIFont systemFontOfSize:12.0f];
    lineOfCreditLabel.textAlignment = NSTextAlignmentCenter;
    [btleftWhiteView addSubview:lineOfCreditLabel];
    _lineOfCreditLabel = lineOfCreditLabel;
    
    //授信额度text
    UILabel *lineOfCreditTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(balanceLabel.frame), ScreenWidth/2-1, 50)];
    lineOfCreditTextLabel.text = @"授信额度";
    lineOfCreditTextLabel.textAlignment = NSTextAlignmentCenter;
    lineOfCreditTextLabel.font = [UIFont systemFontOfSize:14.0f];
    [btleftWhiteView addSubview:lineOfCreditTextLabel];
    
    
//    //可接货额度
//    UIButton *canGetMoneyBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(balanceTextLabel.frame), CGRectGetMaxY(balanceLabel.frame), 70, 50)];
//    //    detailBtn.backgroundColor = [UIColor blueColor];
//    [canGetMoneyBtn setTitle:@"明细及提现" forState:UIControlStateNormal];
//    [canGetMoneyBtn setTitleColor:kFMRedColor forState:UIControlStateNormal];
//    canGetMoneyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [canGetMoneyBtn addTarget:self action:@selector(canGetMoneyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    canGetMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    [btleftWhiteView addSubview:canGetMoneyBtn];
    
    
    //可接货额度
    UILabel *canGetMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth/2-1, 30)];
    canGetMoneyLabel.text = @"元";
    canGetMoneyLabel.font = [UIFont systemFontOfSize:12.0f];
    canGetMoneyLabel.textColor = kFMWordGrayColor;
    canGetMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [btrightWhiteView addSubview:canGetMoneyLabel];
    _canGetMoneyLabel = canGetMoneyLabel;
    
    
    //可接货额度text
    UILabel *canGetMoneyTextLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth/2-140)/2, CGRectGetMaxY(balanceLabel.frame), 80, 50)];
    canGetMoneyTextLabel.text = @"可接货额度";
    canGetMoneyTextLabel.textAlignment = NSTextAlignmentCenter;
    canGetMoneyTextLabel.font = [UIFont systemFontOfSize:14.0f];
    [btrightWhiteView addSubview:canGetMoneyTextLabel];
    
    //冻结明细
    UIButton * freezeListBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(canGetMoneyTextLabel.frame), CGRectGetMaxY(balanceLabel.frame), 60, 50)];
    //    detailBtn.backgroundColor = [UIColor blueColor];
    [freezeListBtn setTitle:@"冻结明细" forState:UIControlStateNormal];
    [freezeListBtn setTitleColor:kFMRedColor forState:UIControlStateNormal];
    freezeListBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [freezeListBtn addTarget:self action:@selector(freezeListBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    freezeListBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btrightWhiteView addSubview:freezeListBtn];


    
    
}
#pragma mark - 更新钱包明细
-(void)updateWalletMessageWithBalance:(NSNumber*)balance andDeposit:(NSNumber*)deposit
{
    NSString *balanceTextStr = [NSString stringWithFormat:@"%.2f元",[balance doubleValue]];
    NSString *balanceBigStr = [NSString stringWithFormat:@"%.2f",[balance doubleValue]];
    NSMutableAttributedString *balanceText = [[NSMutableAttributedString alloc]initWithString:balanceTextStr];
    [balanceText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, balanceBigStr.length)];
    [_balanceLabel setAttributedText:balanceText];
    
    
    NSString *depositTextStr = [NSString stringWithFormat:@"%.2f元",[deposit doubleValue]];
    NSString *depositBigStr = [NSString stringWithFormat:@"%.2f",[deposit doubleValue]];
    NSMutableAttributedString *depositText = [[NSMutableAttributedString alloc]initWithString:depositTextStr];
    [depositText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, depositBigStr.length)];
    [_depositLabel setAttributedText:depositText];
    //授信额度
    NSString *creditTextStr = [NSString stringWithFormat:@"%.2f元",[self.model.creditAmount doubleValue]];
    NSString *creditBigStr = [NSString stringWithFormat:@"%.2f",[self.model.creditAmount doubleValue]];
    NSMutableAttributedString *creditText = [[NSMutableAttributedString alloc]initWithString:creditTextStr];
    [creditText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, creditBigStr.length)];
    [_lineOfCreditLabel setAttributedText:creditText];
    
    //可接受额度usable
    NSString *canGetMoneyTextStr = [NSString stringWithFormat:@"%.2f元(冻结%.2f元)",[self.model.usable doubleValue],[self.model.frozenAmount doubleValue]];
    NSString *canGetMoneyStr = [NSString stringWithFormat:@"%.2f",[deposit doubleValue]];
    NSMutableAttributedString *canGetMoneyText = [[NSMutableAttributedString alloc]initWithString:canGetMoneyTextStr];
    [canGetMoneyText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],NSForegroundColorAttributeName:kFMBlueColor} range:NSMakeRange(0, canGetMoneyStr.length)];
    [canGetMoneyText addAttribute:NSForegroundColorAttributeName value:kFMBlueColor range:NSMakeRange(canGetMoneyStr.length, 1)];
    [_canGetMoneyLabel setAttributedText:canGetMoneyText];
    
    
}
#pragma mark - 网络请求
-(void)initData{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kMYWELLEDGE];
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        FMMyWalletModel *model= [[FMMyWalletModel alloc]initWithDictionary:returnValue[@"data"] error:&error];
        self.model = model;
        [self updateWalletMessageWithBalance:model.balance andDeposit:model.deposit];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        
        
    }];
    
}
#pragma mark - 响应事件
//明细及提现
-(void)detailBtnClicked
{
    FMBalanceViewController *vc = [[FMBalanceViewController alloc]init];
    
    //余额
    NSString *balanceMoney = [NSString stringWithFormat:@"%.2f",[self.model.balance doubleValue]];
    vc.balaceMoney = [NSNumber numberWithDouble:[balanceMoney doubleValue]];
    
    //押金
    NSString *depositMoney = [NSString stringWithFormat:@"%.2f",[self.model.deposit doubleValue]];
    vc.depositMoney = [NSNumber numberWithDouble:[depositMoney doubleValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//查看
-(void)watchBtnClicked
{
    FMDepositViewController *vc = [[FMDepositViewController alloc]init];
    //余额
    NSString *balanceMoney = [NSString stringWithFormat:@"%.2f",[self.model.balance doubleValue]];
    vc.balanceMoney = [NSNumber numberWithDouble:[balanceMoney doubleValue]];
    
    //押金
    NSString *depositMoney = [NSString stringWithFormat:@"%.2f",[self.model.deposit doubleValue]];
    vc.depositMoney = [NSNumber numberWithDouble:[depositMoney doubleValue]];
    
    //押金
    NSString *frozenAmount = [NSString stringWithFormat:@"%.2f",[self.model.frozenAmount doubleValue]];
    vc.frozenAmount = [NSNumber numberWithDouble:[frozenAmount doubleValue]];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
//冻结明细
-(void)freezeListBtnClicked
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMFreezeMoneyController" bundle:nil];
    FMFreezeMoneyController *fresszeMoney = [sb instantiateViewControllerWithIdentifier:@"FMFreezeMoneyController"];
    [self.navigationController pushViewController:fresszeMoney animated:YES];

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
