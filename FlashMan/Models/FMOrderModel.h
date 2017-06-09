//
//  FMOrderModel.h
//  FlashMan
//
//  Created by 小河 on 17/1/18.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol FMOrderModel @end

@interface FMOrderModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional> *id;

//佣金
@property (nonatomic,copy) NSString<Optional> *commission;
//订单金额
@property (nonatomic,copy) NSString<Optional> *orderAmount;

@property (strong, nonatomic) NSString <Optional>*storeName;


//送货地址
@property (nonatomic,copy) NSString<Optional> *storeAddress;

//订单备注
@property (strong, nonatomic) NSString <Optional>*remark;

//取货地址
@property (strong, nonatomic) NSString <Optional>*receiveTime;

@property (strong, nonatomic) NSString <Optional>*warehouseAddress;
//
@property (nonatomic,strong) NSString<Optional> *numberId;
@property (nonatomic,strong) NSString<Optional> *OrderId;
//生成二维码用
@property (strong, nonatomic) NSString <Optional>*rejectCode;
//是否已经付款	0,1
@property(nonatomic,strong)NSNumber <Optional>*hasPay;

//收货单号
@property (strong, nonatomic) NSString *invoiceNumberId;

@end
