//
//  FMWriteCodeViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMWriteCodeViewController.h"

@interface FMWriteCodeViewController ()

@end

@implementation FMWriteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.writeCodeTF.layer.cornerRadius = 3.0f;
    self.writeCodeTF.clipsToBounds = YES;
    
    self.finishedBtn.layer.cornerRadius = 3.0f;
    self.finishedBtn.clipsToBounds = YES;
    [self.finishedBtn addTarget:self action:@selector(finishedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 数据请求－取货
-(void)postGetGoodsDataWithOrderId:(NSString *)orderId {
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kGETGOODS];
    
    NSDictionary *dict = @{
                           @"QRCode":orderId
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        
        [AppUtils dismissHUD];
        [XHView showTipHud:@"取货成功" superView:self.view];

        self.writeCodeTF.text = nil;
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
        
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        [XHView showTipHud:@"取货失败" superView:self.view];
        
    }];
    
    
}
#pragma mark - 响应事件
-(void)finishedBtnClicked
{
    if (self.writeCodeTF.text == nil || [self.writeCodeTF.text isEqualToString:@""]) {
        [XHView showTipHud:@"请输入条形码" superView:self.view];
    }
    else
    {
        [self postGetGoodsDataWithOrderId:self.writeCodeTF.text];
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
