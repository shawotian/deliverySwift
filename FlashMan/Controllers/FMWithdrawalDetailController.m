//
//  FMWithdrawalDetailController.m
//  FlashMan
//
//  Created by dianda on 2017/1/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMWithdrawalDetailController.h"
#import "FMWithdrawalDetailCell.h"

static NSString *const DETAILCELL = @"FMWithdrawalDetailCell";

@interface FMWithdrawalDetailController ()

@end

@implementation FMWithdrawalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现记录";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMWithdrawalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DETAILCELL];
    return cell;
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
