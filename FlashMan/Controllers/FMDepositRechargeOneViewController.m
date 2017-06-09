//
//  FMDepositRechargeOneViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMDepositRechargeOneViewController.h"
#import "FMDepositRechargeViewController.h"

@interface FMDepositRechargeOneViewController ()<UITextFieldDelegate>

@end

@implementation FMDepositRechargeOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"押金充值";
    self.moneyTF.delegate = self;
    self.nextStypeBtn.layer.cornerRadius = 3.0f;
    self.nextStypeBtn.clipsToBounds = YES;
    [self.nextStypeBtn addTarget:self action:@selector(nextBtnCLicked) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)nextBtnCLicked
{
    if (self.moneyTF.text == nil ||[self.moneyTF.text isEqualToString:@""]) {
        [XHView showTipHud:@"请输入充值金额" superView:self.view];
    }
    else
    {
        if ([self.moneyTF.text doubleValue]>=1) {
            FMDepositRechargeViewController *vc = [[FMDepositRechargeViewController alloc]init];
            vc.rechargeMoney = self.moneyTF.text;
            vc.balanceMoney = self.balanceMoney;
            [self.navigationController pushViewController:vc animated:YES];
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
