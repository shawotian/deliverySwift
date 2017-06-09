//
//  FMTransferredViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMTransferredViewController.h"
#import "FMMyWalletViewController.h"
@interface FMTransferredViewController ()<UITextFieldDelegate>

@end

@implementation FMTransferredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转入余额";
    
    self.editMoneyTF.delegate = self;
    
    self.depositMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.depositMoney doubleValue]];;
    self.certainBtn.clipsToBounds = YES;
    self.certainBtn.layer.cornerRadius = 3.0f;
    
    [self.transferredStateBtn addTarget:self action:@selector(transferredClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.certainBtn addTarget:self action:@selector(certainBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)initData{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kBALANCEDEPOSITIN];
    
    NSString *sumStr = [NSString stringWithFormat:@"%.2f",[self.editMoneyTF.text doubleValue]];
    
    NSDictionary *dict = @{
                           @"sum":sumStr
                           };
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        
        [self paySuccess];
        
    } WithErrorCodeBlock:^(id errorCode) {
        
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        
    } WithFailureBlock:^{
        
        [XHView showTipHud:@"转入失败" superView:self.view];
        
    }];
    
}

-(void)paySuccess
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"转入结果"
                                                                   message:@"转入成功！"
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

#pragma mark - 响应事件
//确认转入
-(void)certainBtnClicked
{
    //当前押金金额
    NSString *depositMoneyStr = [NSString stringWithFormat:@"%.2f",[self.depositMoney doubleValue]];
    //需要转入的金额
    NSString *sumStr = [NSString stringWithFormat:@"%.2f",[self.editMoneyTF.text doubleValue]];
    if ([depositMoneyStr doubleValue]>=[sumStr doubleValue])
    {
        [self initData];
        
    }
    else
    {
        [XHView showTipHud:@"当前押金金额不足" superView:self.view];
    }
    
}
//全部转入
-(void)transferredClicked
{
    self.editMoneyTF.text = [NSString stringWithFormat:@"%.2f",[self.depositMoney doubleValue]];
}
//禁止粘贴金额
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
