//
//  FMHomeOrderCell.h
//  FlashMan
//
//  Created by dianda on 2017/1/5.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMOrderModel.h"
@interface FMHomeOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic,strong)FMOrderModel *model;
//收入
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
//冻结
@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;
//取货地址
@property (weak, nonatomic) IBOutlet UILabel *getAddressLabel;
//取货时间
@property (weak, nonatomic) IBOutlet UILabel *getTime;
//收货超市
@property (weak, nonatomic) IBOutlet UILabel *shouStoreLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *shouAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *invoiceNumberLable;

@end
