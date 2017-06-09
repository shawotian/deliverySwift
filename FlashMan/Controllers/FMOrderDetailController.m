//
//  FMOrderDetailController.m
//  FlashMan
//
//  Created by dianda on 2017/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMOrderDetailController.h"
#import "FMOrderAddressCell.h"
#import "FMOrderInfoCell.h"
#import "FMOrderModel.h"

static NSString *const ADDRESSCELL = @"FMOrderAddressCell";
static NSString *const ORDERINFOCELL = @"FMOrderInfoCell";


@interface FMOrderDetailController ()

@property (strong, nonatomic) FMOrderModel *orderModel;
//1:已经接单成功了，0:没有接单
@property(nonatomic,strong)NSNumber *isGetOrder;

@end

@implementation FMOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    [self.tableView registerNib:[UINib nibWithNibName:@"FMOrderAddressCell" bundle:nil] forCellReuseIdentifier:ADDRESSCELL];
    [self.tableView registerNib:[UINib nibWithNibName:@"FMOrderInfoCell" bundle:nil] forCellReuseIdentifier:ORDERINFOCELL];
    
    self.tableView.backgroundColor = kFMLLineGraryColor;
    self.view.backgroundColor  = kFMLLineGraryColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self fetchOrderDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_controllType == JMViewControllerToBeOrdersDetail) {
        if ([self.isGetOrder integerValue]==1) {
            return 3;
        }
        else
        {
            return 4;
        }
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   if (section == 1) {
        return 2;
   }
   else if(section == 2)
   {
       return 3;
   }
   else {
       return 1;
   }


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        FMOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ADDRESSCELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeAddress.text = _orderModel.storeAddress;
        cell.storeNameLable.text = _orderModel.storeName;
        cell.pickDateLable.text = _orderModel.receiveTime;
        cell.pickAddress.text = _orderModel.warehouseAddress;
        return cell;
    }else  {
        
        FMOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ORDERINFOCELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 1:
            {
                if(indexPath.row == 0) {
                    cell.tipsLable.text = @"订单备注：";
                    cell.contentLable.text = _orderModel.remark;
                }else {
                    cell.tipsLable.text = @"订单金额：";
                    cell.contentLable.text = _orderModel.orderAmount;
                }
            }
                break;
            case 2:
            {
                if(indexPath.row == 0) {
                    cell.tipsLable.text = @"运单编号：";
                    cell.contentLable.text = [NSString stringWithFormat:@"%@",_orderModel.numberId];
                    cell.contentLable.textColor = [UIColor blackColor];
                }
                else if(indexPath.row == 1)
                {
                    cell.tipsLable.text = @"订单编号：";
                    cell.contentLable.text = [NSString stringWithFormat:@"%@",_orderModel.OrderId];
                    cell.contentLable.textColor = [UIColor blackColor];
                }else {
                    cell.tipsLable.text = @"发货单号：";
                    cell.contentLable.text = [NSString stringWithFormat:@"%@",_orderModel.invoiceNumberId];
                    cell.contentLable.textColor = [UIColor blackColor];
                    
                }

            }
                break;
            case 3:
            {
                cell.tipsLable.text = @"预期收入：";
                cell.contentLable.text = _orderModel.commission;

            }
                break;
                
        }
        return cell;

    }
    
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            return 138;
        }
            break;
            
        default:
            return 44;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        return 80;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == 3) {
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        UIButton *modifyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        [footerView addSubview:modifyButton];
        modifyButton.backgroundColor = kFMBlueColor;
        [modifyButton setTitle:@"接 单" forState:UIControlStateNormal];
        [modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        modifyButton.layer.cornerRadius = 4.0f;
        modifyButton.clipsToBounds = YES;
        [modifyButton addTarget:self action:@selector(receiveOrder) forControlEvents:UIControlEventTouchUpInside];
        [modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(footerView.mas_left).offset(10);
            make.right.equalTo(footerView.mas_right).offset(-10);
            make.height.equalTo(@45);
            make.top.equalTo(footerView.mas_top).offset(25);
            
        }];
        return footerView;
        
    }else {
        return nil;
    }
}

- (void)receiveOrder {
    
    [self initAcceptOrdersDataWithOrderId:_orderModel.id];
}
//接单
-(void)initAcceptOrdersDataWithOrderId:(NSNumber*)orderId{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kACCEPTORDERS];
    //    url = @"http://192.168.1.215/mockjs/59/v1/order/seckill/list?limit=15&offset=0";
    
    NSDictionary *dict = @{
                           @"deliveryOrderId":orderId
                           };
    [AppUtils showWithStatus:@"正在接单......"];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        [XHView showTipHud:@"已经接单" superView:self.view];
        
        self.isGetOrder = @1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deliverySuccess" object:nil];
        [self fetchOrderDetailData];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
    }];
    
}


#pragma mark - 请求数据
-(void)fetchOrderDetailData{
    
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kORDERDETAIL];
//    url = @"http://192.168.1.215/mockjs/59/v1/order/seckill/detail?deliveryOrderId=";
    NSDictionary *dict = @{
                           @"deliveryOrderId":self.orderID
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        _orderModel = [[FMOrderModel alloc]initWithDictionary:returnValue[@"data"] error:&error];
        
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
}
@end
