//
//  FMFinishedOrderViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMFinishedOrderViewController.h"
#import "FMOrderListJsonModel.h"
#import "FMHomeOrderCell.h"
#import "FMOrderDetailController.h"
static NSString *const HOMEORDERCELL = @"FMHomeOrderCell";
@interface FMFinishedOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
//数据源
@property(nonatomic,strong)FMOrderListJsonModel *jsonModel;
//当前操作的model
@property(nonatomic,strong)FMOrderModel *model;
@property (strong, nonatomic) UITableView *tableView;
//分页加载标记
@property(nonatomic,assign)NSInteger pageNum;
@property (strong, nonatomic)UILabel *finishedCountLabel;
@property (strong, nonatomic)UILabel *totalCountLabel;

@end

@implementation FMFinishedOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.controllType == JMViewControllerFinished){
        self.title = @"已完成订单";
    }
    else
    {
        self.title = @"已取消订单";
    }
    
    self.headerView.hidden = YES;
    self.footerView.hidden = YES;
    
    [self addSubViews];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 搭建界面
-(void)addSubViews
{
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    tv.delegate = self;
    tv.dataSource = self;
    tv.estimatedRowHeight = 170;
    tv.rowHeight = UITableViewAutomaticDimension;
    tv.backgroundColor = kFMLLineGraryColor;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    _tableView = tv;
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [tv registerNib:[UINib nibWithNibName:@"FMHomeOrderCell" bundle:nil] forCellReuseIdentifier:HOMEORDERCELL];
    
    //自定义头部刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(orderListHeaderBeganRefresh)];
    // 设置header
    _tableView.mj_header=[XHView customTopHeaderWithHearder:header];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(orderListFooterBeganRefresh)];
        _tableView.mj_footer=footer;
    
    [footer setTitle:@"已无更多数据" forState:MJRefreshStateNoMoreData];
    
    [self initDataWithPageNum:_pageNum];
    [self addTableviewHeader];
}
-(void)addTableviewHeader
{
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    backGroundView.backgroundColor = kFMLLineGraryColor;
    
    //今日完成订单数
    
    UIView *finishedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 100)];
    finishedView.backgroundColor = [UIColor whiteColor];
    [backGroundView addSubview:finishedView];
    
    
    UILabel *finishedCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth/2, 30)];
    finishedCountLabel.text = @"0";
    finishedCountLabel.textAlignment = NSTextAlignmentCenter;
    finishedCountLabel.font = [UIFont systemFontOfSize:20.0f];
    finishedCountLabel.textColor = kFMBlueColor;
    [finishedView addSubview:finishedCountLabel];
    _finishedCountLabel = finishedCountLabel;
    
    UILabel *finishedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth/2, 30)];
    if (self.controllType == JMViewControllerFinished){
        finishedLabel.text = @"今日完成订单数";
    }
    else
    {
        finishedLabel.text = @"今日取消订单数";
    }
    
    finishedLabel.font = [UIFont systemFontOfSize:14.0f];
    finishedLabel.textAlignment = NSTextAlignmentCenter;
    finishedLabel.textColor = [UIColor colorWithHexString:@"282828"];
    [finishedView addSubview:finishedLabel];
    
    //累积结束订单数
    UIView *totalView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(finishedView.frame)+1, 0, ScreenWidth/2, 100)];
    totalView.backgroundColor = [UIColor whiteColor];
    [backGroundView addSubview:totalView];
    
    UILabel *totalCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth/2, 30)];
    totalCountLabel.text = @"0";
    totalCountLabel.textAlignment = NSTextAlignmentCenter;
    totalCountLabel.font = [UIFont systemFontOfSize:20.0f];
    totalCountLabel.textColor = kFMBlueColor;
    [totalView addSubview:totalCountLabel];
    _totalCountLabel = totalCountLabel;
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth/2, 30)];
    if (self.controllType == JMViewControllerFinished)
    {
        totalLabel.text = @"累积结束订单数";
    }
    else
    {
        totalLabel.text = @"累积取消订单数";
    }
    
    totalLabel.font = [UIFont systemFontOfSize:14.0f];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.textColor = [UIColor colorWithHexString:@"282828"];
    [totalView addSubview:totalLabel];

    
    _tableView.tableHeaderView = backGroundView;
    
}
#pragma mark - 请求数据
-(void)initDataWithPageNum:(NSInteger)pageNum{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kHISTORYORDERLIST];
//    url = @"http://192.168.1.215/mockjs/59/v1/order/delivery/listOrders?state=1";
    
    NSNumber *orderState;
    NSInteger offset = pageNum*15;
    //已完成
    if (self.controllType == JMViewControllerFinished){
        orderState = @4;
    }//已取消
    else
    {
        orderState = @5;
    }
    
    
    NSDictionary *dict = @{
                           
                           @"limit":@15,
                           
                           @"offset":[NSNumber numberWithInteger:offset],
                           @"state":orderState
                           };
    
    [request NetRequestGETWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        FMOrderListJsonModel *jsonModel= [[FMOrderListJsonModel alloc]initWithDictionary:returnValue[@"data"] error:&error];
        _finishedCountLabel.text = [jsonModel.todayOrderCount stringValue];
        _totalCountLabel.text = [jsonModel.allOrderCount stringValue];
        if (offset == 0) {
            self.jsonModel = jsonModel;
            
        }else {
            [self.jsonModel.list addObjectsFromArray:(NSArray*)jsonModel.list];
        }
        if (jsonModel.list.count < 15) {
            //结束头部刷新
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            [_tableView reloadData];
            
        }
        else
        {
            //结束头部刷新
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        
        
        
    
    } WithErrorCodeBlock:^(id errorCode) {

        [AppUtils dismissHUD];
        //结束头部刷新
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];

    } WithFailureBlock:^{
   
        [AppUtils dismissHUD];
        //结束头部刷新
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    }];
    
}
#pragma mark - delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.jsonModel.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMHomeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:HOMEORDERCELL];
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    cell.model = self.jsonModel.list[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMOrderModel *model = self.jsonModel.list[indexPath.section];
    FMOrderDetailController *orderD = [[FMOrderDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    orderD.orderID = model.id;
    orderD.controllType = JMViewControllerFinishedDetail;
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] pushViewController:orderD animated:YES];
    
}
#pragma mark - 刷新
-(void)orderListHeaderBeganRefresh
{
    _pageNum = 0;
    [self initDataWithPageNum:_pageNum];
}
-(void)orderListFooterBeganRefresh
{
    _pageNum ++;
    [self initDataWithPageNum:_pageNum];
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
