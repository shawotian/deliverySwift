//
//  FMMenuViewController.m
//  FlashMan
//
//  Created by taitanxiami on 2017/1/4.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMMenuViewController.h"
#import "FMMenuTopView.h"
#import "RHMeContentCell.h"
#import "FMPaymentViewController.h"
#import "FMNavigationController.h"
//钱包
#import "FMMyWalletViewController.h"
#import "FMSettingController.h"
#import "FMMeCurrentHouseCell.h"
#import "FMWarehourseEntity.h"
#import "FMWarehouseScanViewController.h"

static NSString *const CONTENTCELL = @"MeContentCell";
static NSString *const CURRENTHOURSECELL = @"FMMeCurrentHouseCell";

@interface FMMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FMMenuTopView *topView;

@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) NSArray *images;

@property (strong, nonatomic) FMWarehourseEntity *warehourseEntity;
@end

@implementation FMMenuViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self fetchCurrentWareHourse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenueData) name:@"logInSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenueData) name:@"logOutSuccess" object:nil];
    
    
    self.titles = @[@"到仓确认",@"交货款",@"钱包",@"设置"];
    self.images = @[@"menu_icon_daocang",@"menu_icon_huokuan",@"menu_icon_qianbao",@"menu_icon_shezhi"];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"FMMenuTopView" owner:self options:nil] lastObject];
    CGRect newFrame = _topView.frame;
    newFrame.size.height = 140;
    _topView.frame = newFrame;
    
    _topView.phoneNumLable.text = [GVUserDefaults standardUserDefaults].phoneNum;
    self.tableView.tableHeaderView = _topView;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RHMeContentCell" bundle:nil] forCellReuseIdentifier:CONTENTCELL];
    [self.tableView registerNib:[UINib nibWithNibName:@"FMMeCurrentHouseCell" bundle:nil] forCellReuseIdentifier:CURRENTHOURSECELL];

    self.tableView.tableFooterView = [UIView new];
 
}
#pragma mark - 数据请求
//获取用户当前前置仓
-(void)fetchCurrentWareHourse{
    
    NetRequestClass *request = [[NetRequestClass alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kCURRENTWAREHOURSE];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        
        NSError *error = nil;
        _warehourseEntity = [[FMWarehourseEntity alloc]initWithDictionary:returnValue[@"data"] error:&error];
        
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

#pragma mark - delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        FMMeCurrentHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:CURRENTHOURSECELL];
        cell.contentLable.text = self.titles[indexPath.row];
        cell.tipsImageView.image = [UIImage imageNamed:self.images[indexPath.row]];
        
        cell.wareHourseLable.text = _warehourseEntity.warehouseAddress ? : @"无";
        return cell;
        
    }else {
        
        RHMeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CONTENTCELL];
        cell.contentLable.text = self.titles[indexPath.row];
        cell.tipImageView.image = [UIImage imageNamed:self.images[indexPath.row]];
        if(indexPath.row == 1)
        {
            cell.moneyLabel.hidden = NO;
            cell.moneyLabel.text = [NSString stringWithFormat:@"代缴金额：%.2f",[_warehourseEntity.sum doubleValue]];
        }
        else
        {
            cell.moneyLabel.hidden = YES;
        }
        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return 73;
    }else {
        return 50;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            FMWarehouseScanViewController *vc = [[FMWarehouseScanViewController alloc]init];
            FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
            
            [nav pushViewController:vc animated:YES];
            [self.frostedViewController hideMenuViewController];
        }
            break;
        case 1:
        {
            FMPaymentViewController *patmentController = [[FMPaymentViewController alloc]init];
            FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
            
            [nav pushViewController:patmentController animated:YES];
            [self.frostedViewController hideMenuViewController];

        }
            break;
        case 2:
        {
            //钱包
            FMMyWalletViewController *vc = [[FMMyWalletViewController alloc]init];
            FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
            [nav pushViewController:vc animated:YES];
            [self.frostedViewController hideMenuViewController];
            
            
        }
            break;
        case 3:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMSettingController" bundle:nil];
            FMSettingController *balanceRechargeVC = [sb instantiateViewControllerWithIdentifier:@"FMSettingController"];
            
            FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
            
            [nav pushViewController:balanceRechargeVC animated:YES];
            [self.frostedViewController hideMenuViewController];
            
        }
            break;
    }
}

#pragma mark - 响应事件
-(void)updateMenueData
{
    _topView.phoneNumLable.text = [GVUserDefaults standardUserDefaults].phoneNum;
    self.tableView.tableHeaderView = _topView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
