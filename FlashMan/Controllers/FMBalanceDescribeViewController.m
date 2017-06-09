//
//  FMBalanceDescribeViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/21.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMBalanceDescribeViewController.h"

@interface FMBalanceDescribeViewController ()

@end

@implementation FMBalanceDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"余额明细";
    [self initData];
    
}
-(void)setModel:(FMBalanceModel *)model
{
    self.chuzhangMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[model. transferAmount doubleValue]];
    self.typeLabel.text = model.typeState;
    self.timeLabel.text = model.createdAt;
    self.yunDanIdLabel.text = model.numberId;
    self.jiaoyIdLabel.text = model.tradeNumberId;

}
-(void)initData{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kBALANCEDESCRIBTION];
    NSDictionary *dict = @{
                           
                           @"id":[self.balanceId stringValue]
                           
                           };
    [request NetRequestGETWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        NSError *error = nil;
        FMBalanceModel *model= [[FMBalanceModel alloc]initWithDictionary:returnValue[@"data"] error:&error];
        self.model = model;
        
        
    } WithErrorCodeBlock:^(id errorCode) {
       
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
    } WithFailureBlock:^{

        
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
