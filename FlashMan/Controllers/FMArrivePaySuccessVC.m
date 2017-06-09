//
//  FMArrivePaySuccessVC.m
//  FlashMan
//
//  Created by 小河 on 17/3/31.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMArrivePaySuccessVC.h"

@interface FMArrivePaySuccessVC ()

@end

@implementation FMArrivePaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_payType == SMViewControllerSuccessWeChatPay) {
        self.title = @"微信收款";
    }
    else
    {
        self.title = @"支付宝收款";
    }
    
    self.navigationItem.hidesBackButton = YES;
    self.whiteView.layer.cornerRadius = 3.0f;
    self.whiteView.clipsToBounds = YES;
    
    self.finishedBtn.layer.cornerRadius = 3.0f;
    self.finishedBtn.clipsToBounds = YES;
    [self.finishedBtn addTarget:self action:@selector(finishedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.tradeNumberLabel.text = [NSString stringWithFormat:@"交易单号：%@",self.successModel.tradeRecordNo];
    self.tradeDateLabel.text = [NSString stringWithFormat:@"交易时间：%@",self.successModel.time];
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",self.orderID];
    self.moneyLabel.text = [NSString stringWithFormat:@"金额：%@",self.successModel.orderAmount];

}
-(void)finishedBtnClicked
{
   
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] popToRootViewControllerAnimated:YES];
    
    
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
