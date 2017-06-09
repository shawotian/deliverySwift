//
//  FMFreezeMoneyController.m
//  FlashMan
//
//  Created by dianda on 2017/1/20.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMFreezeMoneyController.h"
#import "FMFreezeMoneyCell.h"

#import "FMFresszeMoneyEntity.h"
static NSString *const FMFreezeMoneyCellIdentity = @"FMFreezeMoneyCell";

@interface FMFreezeMoneyController ()


//数据源
@property (strong, nonatomic) NSMutableArray  *fresszes;

//分页
@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation FMFreezeMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"冻结明细";
    self.tableView.tableFooterView = [UIView new];
    
    
    //自定义头部刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(orderListHeaderBeganRefresh)];
    // 设置header
    self.tableView.mj_header=[XHView customTopHeaderWithHearder:header];
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(orderListFooterBeganRefresh)];
//    self.tableView.mj_footer=footer;
//    
    
    [self fetchFresszeMoneyDataWithPage:_pageNum];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fresszes.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMFreezeMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:FMFreezeMoneyCellIdentity];
    
    FMFresszeMoneyEntity *entity = self.fresszes[indexPath.row];
    
    cell.dateLable.text = entity.updatedAt;
    cell.orderIDLable.text = [NSString stringWithFormat:@"%@",entity.numberId];
    cell.finishSateLable.text = entity.finishSate;
    cell.stateLable.text = entity.state;
    cell.moneyLable.text = [NSString stringWithFormat:@"%.2f",[entity.orderAmount doubleValue]];
    
    return cell;
    
}


-(NSMutableArray *)fresszes {
    if (!_fresszes) {
        _fresszes = [NSMutableArray arrayWithCapacity:1];
    }
    return _fresszes;
}
-(void)fetchFresszeMoneyDataWithPage:(NSInteger)pageNum{
    NSInteger offset = pageNum*15;
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,KFRESSZEDETAIL];
    NSDictionary *dic = @{
                          @"limit":@15,
                              @"offset":[NSNumber numberWithInteger:offset]
                          };
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        
        NSArray *arr = [FMFresszeMoneyEntity arrayOfModelsFromDictionaries:returnValue[@"data"] error:&error];
        
        if (pageNum == 0) {
            self.fresszes = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.fresszes addObjectsFromArray:arr];
        }
        
        //结束头部刷新
        [self.tableView.mj_header endRefreshing];
//        if (arr.count < 15) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
            [self.tableView.mj_footer endRefreshing];
            
//        }
        
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
//刷新
-(void)orderListHeaderBeganRefresh
{
    _pageNum = 0 ;
    [self fetchFresszeMoneyDataWithPage:_pageNum];
}
-(void)orderListFooterBeganRefresh
{
    _pageNum++;
    [self fetchFresszeMoneyDataWithPage:_pageNum];
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
