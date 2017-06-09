//
//  FMPaymentViewController.m
//  FlashMan
//
//  Created by dianda on 2017/1/7.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMPaymentViewController.h"
#import "FMPayMentCell.h"
#import "FMPaymentStateView.h"
#import "FMPaymentEntity.h"
#import "FMOrderPayViewController.h"
static NSString *const PAYMENTCELL  = @"FMPayMentCell";

@interface FMPaymentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) FMPaymentStateView *stateView;
@property (strong, nonatomic) UITableView *tableView;
//数据源
@property (strong, nonatomic) NSMutableArray *payments;

@property (assign, nonatomic) NSInteger offset;

//ids数组
@property(nonatomic,strong)NSMutableArray *idsArr;
//sum
@property(nonatomic,assign)double paySum;
@end

@implementation FMPaymentViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"交货款";
    self.offset = 0;

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
    }];
//    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FMPayMentCell" bundle:nil] forCellReuseIdentifier:PAYMENTCELL];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(@44);
    }];
    [self.stateView.submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];

//    [self.view layoutIfNeeded];
//    [UIView animateWithDuration:2
//                     animations:^{
//                         
//                         [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
//                             
//                             make.left.and.right.and.bottom.equalTo(self.view);
//                             make.top.equalTo(self.tableView.mas_bottom);
//                             make.height.equalTo(@44);
//                         }];
//                         [self.view layoutIfNeeded];
//                     }];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self fetchFresszeMoneyData];
    }];
        
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.triggerAutomaticallyRefreshPercent  = -30;
    self.tableView.mj_footer = footer;
    _idsArr = [NSMutableArray arrayWithCapacity:0];
    [self fetchFresszeMoneyData];
}
- (void)loadMore {
    self.offset += 20;
    [self fetchFresszeMoneyData];

}
-(void)submitBtnClicked
{
    if (_idsArr.count>0) {
        FMOrderPayViewController *vc = [[FMOrderPayViewController alloc]init];
        vc.idsArr = _idsArr;
        vc.rechargeMoney = [NSString stringWithFormat:@"%.2f",_paySum];
        vc.controllType = JMViewControllerPayTypeSubMit;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        [XHView showTipHud:@"请选择交货款条目" superView:self.view];
    }
}

- (NSMutableArray *)payments {
    if(!_payments) {
        _payments = [NSMutableArray arrayWithCapacity:2];
    }
    return _payments;
}

- (FMPaymentStateView *)stateView {
    
    if (!_stateView) {
        _stateView = [[[NSBundle mainBundle] loadNibNamed:@"FMPaymentStateView" owner:self options:nil] lastObject];
        [self.view addSubview:_stateView];
        
        
    }
    return _stateView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _payments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMPayMentCell *cell = [tableView dequeueReusableCellWithIdentifier:PAYMENTCELL];
    FMPaymentEntity *entity = self.payments[indexPath.row];
    cell.orderIDLable.text = [NSString stringWithFormat:@"%@",entity.numberId];
    cell.orderAmountLable.text = [NSString stringWithFormat:@"¥%.2f",[entity.orderAmount doubleValue]];
    
    if (entity.isSelect.integerValue == 1) {
        [cell.stateButton setImage:[UIImage imageNamed:@"content_button_pressed"] forState:UIControlStateNormal];
    }else {
        [cell.stateButton setImage:[UIImage imageNamed:@"content_button_normal"] forState:UIControlStateNormal];
    }
    [cell.stateButton addTarget:self action:@selector(stateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.stateButton.tag = indexPath.row + 100;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMPaymentEntity *entity = self.payments[indexPath.row];
    
    NSInteger state =   entity.isSelect.integerValue;
    entity.isSelect = state == 0 ? @1 : @0;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self updateStateViewStatus];
}

- (void)updateStateViewStatus {
    
    NSInteger count = 0;
    _paySum = 0.0;
    [_idsArr removeAllObjects];
    for (FMPaymentEntity *entity in self.payments) {
        
        if (entity.isSelect.integerValue == 1) {
            count ++;
            _paySum += entity.orderAmount.doubleValue;
            [_idsArr addObject:entity.id];
        }
    }
    _stateView.countLable.text = [NSString stringWithFormat:@"%ld",count];
    _stateView.priceLable.text = [NSString stringWithFormat:@"¥%.2f",_paySum];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)fetchFresszeMoneyData{
    
    NetRequestClass *request = [[NetRequestClass alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@%@?offset=%ld&limit=20",SERVER_ADDRESS,kPAYMENTLIST,self.offset];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        
        NSError *error = nil;

        NSArray *arr = [FMPaymentEntity arrayOfModelsFromDictionaries:returnValue[@"data"] error:&error];
        if(self.offset == 0) {
            self.payments = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.payments addObjectsFromArray:arr];
        }
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        
        if (arr.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];

        }

        
        [self.tableView reloadData];
    } WithErrorCodeBlock:^(id errorCode) {
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
    } WithFailureBlock:^{
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
}

-(void)stateButtonClicked:(UIButton*)btn
{
    //进入付款页面
    
}
@end
