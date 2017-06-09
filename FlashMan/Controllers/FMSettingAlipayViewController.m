//
//  FMSettingAlipayViewController.m
//  FlashMan
//
//  Created by 小河 on 17/2/8.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMSettingAlipayViewController.h"

@interface FMSettingAlipayViewController ()

@end

@implementation FMSettingAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加支付宝账号";
    // Do any additional setup after loading the view from its nib.
    [self.finishBtn addTarget:self action:@selector(finishBtnCliced) forControlEvents:UIControlEventTouchUpInside];
}
-(void)finishBtnCliced
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kADDALIPAYACCOUNT];
    NSDictionary *dict = @{
                         @"account":self.alipyNumber.text,
                             @"realName":self.nameTF.text
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"绑定支付宝成功";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            
            [HUD removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSetting" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];

        
    } WithErrorCodeBlock:^(id errorCode) {
       
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        
    } WithFailureBlock:^{
       
        [AppUtils dismissHUD];
        [XHView showTipHud:@"绑定支付宝失败" superView:self.view];
        
    }];

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
