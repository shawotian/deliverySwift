//
//  FMHomeOrderCell.m
//  FlashMan
//
//  Created by dianda on 2017/1/5.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMHomeOrderCell.h"

@implementation FMHomeOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 3.0f;
    self.bgView.layer.masksToBounds = YES;
}
-(void)setModel:(FMOrderModel *)model {
    
    _model = model;
    //收入
    self.profitLabel.text = [NSString stringWithFormat:@"%.2f",[model.commission doubleValue]];
    //冻结
    self.freezeLabel.text = [NSString stringWithFormat:@"冻结：%.2f元",[model.orderAmount doubleValue]];
    //取货地址
    self.getAddressLabel.text = model.warehouseAddress;
    //取货时间
    self.getTime.text = model.receiveTime;
    //超市名字
    self.shouStoreLabel.text = model.storeName;
    //收货地址
    self.shouAddressLabel.text = model.storeAddress;
    self.invoiceNumberLable.text = model.invoiceNumberId;
}
@end
