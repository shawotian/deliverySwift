//
//  FMHomeViewController.m
//  FlashMan
//
//  Created by taitanxiami on 2017/1/4.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMHomeViewController.h"
#import "FMNavigationController.h"
#import "FMHomeOrderCell.h"
#import "FMLoginViewController.h"
#import "FMOrderDetailController.h"
#import "FMMyTaskViewController.h"
#import "FMOrderListJsonModel.h"
#import "FMAcceptOrdersView.h"
#import "DDScanViewController.h"

static NSString *const HOMEORDERCELL = @"FMHomeOrderCell";

@interface FMHomeViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//0:登录，注册 1:我的任务，刷新列表
@property(nonatomic,strong)NSNumber *typeState;
//分页加载标记
@property(nonatomic,assign)NSInteger pageNum;
//数据源
@property(nonatomic,strong)FMOrderListJsonModel *jsonModel;
//
@property(nonatomic,strong)UIView *acceptViewLayer;
@end

@implementation FMHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeData) name:@"logInSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutUpdataData) name:@"logOutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeData) name:@"deliverySuccess" object:nil];
    
    NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
    if (token == nil || [token isEqualToString:@""]) {
        
        _typeState = [NSNumber numberWithInteger:0];
        
        [self.logInBtn setTitle:@"登录" forState:UIControlStateNormal];
        
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
        FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.type = FMLoginTypeLogin;
        [self.navigationController pushViewController:loginVC animated:NO];
        
    }
    else
    {
        _typeState = [NSNumber numberWithInteger:1];
    
        [self.logInBtn setTitle:@"我的任务" forState:UIControlStateNormal];
        
        [self.registerBtn setTitle:@"刷新列表" forState:UIControlStateNormal];
        [self initDataWithPageNum:_pageNum];
    }
    
    self.navigationItem.title = @"可接的单";
   
    
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 17, 20)];
    [leftbutton setImage:[UIImage imageNamed:@"nav_leftbutton_geren"] forState:UIControlStateNormal];
    [leftbutton addTarget:(FMNavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
        
    self.tableView.estimatedRowHeight = 170;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = kFMLLineGraryColor;
    self.view.backgroundColor  = kFMLLineGraryColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FMHomeOrderCell" bundle:nil] forCellReuseIdentifier:HOMEORDERCELL];
    //自定义头部刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(orderListHeaderBeganRefresh)];
    // 设置header
    _tableView.mj_header=[XHView customTopHeaderWithHearder:header];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(orderListFooterBeganRefresh)];
    _tableView.mj_footer=footer;
    
    [footer setTitle:@"已无更多数据" forState:MJRefreshStateNoMoreData];
    
    
    

}
#pragma mark - 请求数据
//请求首页数据
-(void)initDataWithPageNum:(NSInteger)pageNum{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kORDERLIST];
//    url = @"http://192.168.1.215/mockjs/59/v1/order/seckill/list?limit=15&offset=0";
    NSInteger offset = pageNum*15;
    NSDictionary *dict = @{
                           @"limit":@15,
                               @"offset":[NSNumber numberWithInteger:offset]
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        FMOrderListJsonModel *jsonModel= [[FMOrderListJsonModel alloc]initWithDictionary:returnValue error:&error];
        
        if (offset == 0) {
            self.jsonModel = jsonModel;
            
        }else {
            [self.jsonModel.data addObjectsFromArray:(NSArray*)jsonModel.data];
        }
        if (jsonModel.data.count<15) {
            //结束头部刷新
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshingWithNoMoreData];

        }
        else
        {
            //结束头部刷新
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
        
        [_tableView reloadData];
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        NSString *token  = [UserDefaultsUtils valueWithKey:kToken];
        if([token isEqualToString:@""]||token == nil)
        {
            [XHView showTipHud:@"尚未登录或已失效，请重新登录" superView:self.view];
        }
        else
        {
            [XHView showTipHud:errorCode[@"message"] superView:self.view];
        }
        //结束头部刷新
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];

    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        //结束头部刷新
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        
    }];

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
        [self orderListHeaderBeganRefresh];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
    }];
   
}
// 版本更新
- (void)checkVersion {
    
    __weak typeof(self) weakself = self;
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSDictionary *paramas = @{@"type":@1};
    NetRequestClass *request = [[NetRequestClass alloc]init];
    NSString *url =  [NSString stringWithFormat:@"%@/system/version",SERVER_ADDRESS];
    [request NetRequestGETWithRequestURL:url WithParameter:paramas WithReturnValeuBlock:^(id returnValue) {
        
        NSDictionary *newVersion = returnValue[@"data"];
        NSInteger firstString = [newVersion[@"code"] integerValue];
        NSInteger code = build.integerValue;
        if (code < firstString) {
            [weakself showVersionInfo:newVersion];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils showErrorMessage:errorCode[kMESSAGE]];
        
    } WithFailureBlock:^{
        
    }];
    
    
}

//版本更新弹框
- (void)showVersionInfo:(NSDictionary *)newVersion {
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到新版本" message:newVersion[@"content"] preferredStyle:UIAlertControllerStyleAlert];
    if([newVersion[@"upgradeFlag"] integerValue] == 0) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *handler){
            
            NSURL *url = [NSURL URLWithString:APP_DOWNLOADURL];
            [[UIApplication sharedApplication] openURL:url];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
    }else {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *handler){
            NSURL *url = [NSURL URLWithString:APP_DOWNLOADURL];
            [[UIApplication sharedApplication] openURL:url];
            [weakself showVersionInfo:newVersion];
        }];
        [alertController addAction:okAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - delegate && dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.jsonModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMHomeOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:HOMEORDERCELL];
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    cell.model = self.jsonModel.data[indexPath.section];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    backGroundView.backgroundColor = kFMLLineGraryColor;
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 45)];
    whiteView.backgroundColor = kFMLLineGraryColor;
    whiteView.layer.cornerRadius = 3.0f;
    whiteView.clipsToBounds = YES;
    [backGroundView addSubview:whiteView];

    
    UIButton *getbtn = [XHView createBtnWithFrame:CGRectMake(0, 0, ScreenWidth-20, 45) text:@"接 单" textColor:kFMBlueColor backgroundColor:[UIColor whiteColor] setImgName:nil target:self action:@selector(getbtnClicked:) superView:whiteView];
    getbtn.tag = 100 + section;
    
    return backGroundView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMOrderDetailController *orderD = [[FMOrderDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    FMOrderModel *model = self.jsonModel.data[indexPath.section];
    orderD.orderID = model.id;
    orderD.controllType = JMViewControllerToBeOrdersDetail;
    [self.navigationController pushViewController:orderD animated:YES];
}
#pragma mark - 响应事件
//接单按钮被点击
-(void)getbtnClicked:(UIButton*)btn
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.layer.contents = (__bridge id) [UIImage imageNamed:@"fdbeij"].CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:view];
    _acceptViewLayer = view;
    [[UIApplication sharedApplication].keyWindow addSubview:_acceptViewLayer];
    
    //谈框
    FMAcceptOrdersView *transactionView = [[[NSBundle mainBundle] loadNibNamed:@"FMAcceptOrdersView" owner:self options:nil]lastObject];
    transactionView.frame = CGRectMake((ScreenWidth-280)/2, (ScreenHeight-180)/2, 280, 180);
    transactionView.backgroundColor = [UIColor whiteColor];
    transactionView.clipsToBounds = YES;
    transactionView.layer.cornerRadius = 3.0f;
    [transactionView.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [transactionView.certainBtn addTarget:self action:@selector(certainBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    transactionView.certainBtn.tag = btn.tag;
    [_acceptViewLayer addSubview:transactionView];
    
    
    
}
//接单弹框－取消按钮被点击
-(void)cancelBtnClicked
{
    [_acceptViewLayer removeFromSuperview];
}
//接单弹框－确定按钮被点击
-(void)certainBtnClicked:(UIButton*)btn
{
    
    
    [_acceptViewLayer removeFromSuperview];
    NSInteger sectionNum = btn.tag -100;
    FMOrderModel *model = self.jsonModel.data[sectionNum];
    [self initAcceptOrdersDataWithOrderId:model.id];
    
}

//登录按钮被点击
- (IBAction)showLogin:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
    if ([_typeState integerValue] == 0) {
        FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.type = FMLoginTypeLogin;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        //我的任务
        FMMyTaskViewController *vc = [[FMMyTaskViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    

}

//注册按钮被点击
- (IBAction)showRegister:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
    if ([_typeState integerValue] == 0) {
        FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.type = FMLoginTypeRegister;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        //刷新列表
        _pageNum = 0;
        [self initDataWithPageNum:_pageNum];
    }
    
    
}


#pragma mark - 通知的响应事件
//登录成功 更新首页数据
-(void)updateHomeData
{
    _typeState = [NSNumber numberWithInteger:1];
    [self.logInBtn setTitle:@"我的任务" forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"刷新列表" forState:UIControlStateNormal];
    [self.jsonModel.data removeAllObjects];
    _pageNum = 0;
    [self initDataWithPageNum:_pageNum];
}

//退出登录  更新首页数据
-(void)logOutUpdataData
{
    [UserDefaultsUtils saveValue:nil forKey:kToken];
    
    _typeState = [NSNumber numberWithInteger:0];
    
    [self.logInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    [self.jsonModel.data removeAllObjects];
    _pageNum = 0;
    [self.tableView reloadData];
}
#pragma mark - 刷新
-(void)orderListHeaderBeganRefresh
{
    _pageNum = 0;
    [self initDataWithPageNum:_pageNum];
}
-(void)orderListFooterBeganRefresh{
    _pageNum++;
    [self initDataWithPageNum:_pageNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
