//
//  FMApplicationWithdrawViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMApplicationWithdrawViewController.h"
#import "FMMyWalletViewController.h"
#import "FMWithDrawSuccessViewController.h"
@interface FMApplicationWithdrawViewController ()<UITextFieldDelegate>

@end

@implementation FMApplicationWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额提现";
    self.moneyTF.delegate = self;
    self.headerView.clipsToBounds = YES;
    self.headerView.layer.cornerRadius = 3.0f;
    
    self.checkView.layer.cornerRadius = 3.0f;
    self.checkView.clipsToBounds = YES;
    
    self.checkBtn.layer.cornerRadius = 3.0f;
    self.checkBtn.clipsToBounds = YES;
    [self.checkBtn addTarget:self action:@selector(ssendsSMS:) forControlEvents:UIControlEventTouchUpInside];
 
    self.withDrawBtn.clipsToBounds = YES;
    [self.withDrawBtn addTarget:self action:@selector(withDrawBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //当前余额
    self.currentBalanceLabel.text = [NSString stringWithFormat:@"当前零钱余额：%.2f",[self.leftMoney doubleValue]];
    
    //支付宝账号
    self.bankCardLabel.text = [NSString stringWithFormat:@"%@",self.model.accountNo];
    
    // Do any additional setup after loading the view from its nib.
    
    
}

#pragma mark - 数据请求
//获取验证码接口
-(void)ggetCodeStr
{
    NetRequestClass *netrequest =  [[NetRequestClass alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kCHECKCODE];
    
    [AppUtils showWithStatus:nil];
    [netrequest NetRequestPOSTWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
    }];
    
}
//调取提现接口
-(void)initData
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kWITHDRAW];
    
    NSDictionary *dict = @{
                           @"sum":self.moneyTF.text,
                           @"validateCode":self.checkTF.text,
                           @"accountNo":self.model.accountNo,
                               @"userName":self.model.userName
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        FMWithDrawSuccessViewController *vc = [[FMWithDrawSuccessViewController alloc]init];
        vc.withDrawMoney = self.moneyTF.text;
        vc.alipyNum = self.model.accountNo;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        [XHView showTipHud:@"提现失败" superView:self.view];
        
    }];
    
}

#pragma mark - 响应事件
//获取验证码按钮被点击
- (void)ssendsSMS:(JKCountDownButton *)sender {
    
    [self ggetCodeStr];
    sender.enabled = NO;
    [sender startCountDownWithSecond:60];
    [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%zds",second];
        return title;
    }];
    
    [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"获取验证码";
    }];
}
//提现按钮被点击
-(void)withDrawBtnClicked
{
    if(self.moneyTF.text == nil ||[self.moneyTF.text isEqualToString:@""]|| self.checkTF.text == nil || [self.checkTF.text isEqualToString:@""])
    {
        [XHView showTipHud:@"请输入提现金额和验证码" superView:self.view];

    }
    else
    {
        
        if([self.moneyTF.text doubleValue]>=1)
        {
            [self initData];
        }
        else
        {
            [XHView showTipHud:@"请输入至少1元的金额" superView:self.view];
        }
        
    }
    
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (int i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                
                [XHView showTipHud:@"最多输入小数点后两位" superView:self.view];
                
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
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
