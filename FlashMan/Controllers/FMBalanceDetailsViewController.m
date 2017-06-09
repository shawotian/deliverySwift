//
//  FMBalanceDetailsViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMBalanceDetailsViewController.h"
#import "FMBalanceDetailsTableViewCell.h"
#import "FMBalanceJsonModeal.h"
#import "FMTransactionView.h"
#import "FMBalanceDescribeViewController.h"

@interface FMBalanceDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UITableView *tv;

//日历layer
@property(nonatomic,strong)UIView *calendarViewLayer;
//筛选layer
@property(nonatomic,strong)UIView *filterViewLayer;

//数据源
@property(nonatomic,strong)FMBalanceJsonModeal *jsonModel;
@property(nonatomic,strong)UIPickerView *datePicker;
@property(nonatomic,strong)NSMutableArray *pickerYearData;
@property(nonatomic,strong)NSArray *pickerMonthData;
@property(nonatomic,strong)UILabel *selectedDataLabel;
@property(nonatomic,strong)NSString *yearStr;
@property(nonatomic,strong)NSString *monthStr;
//筛选
@property(nonatomic,strong)UIView *transactionView;
@property(nonatomic,strong)UIView *cancelBtn;
@property(nonatomic,assign)NSInteger pageNum;
//余额明细状态 0:全部 -3: 违约金 -2: 充值押金 -1: 提现 1: 配送收入 2: 押金转余额
@property(nonatomic,assign)NSInteger recordsNum;

@end

@implementation FMBalanceDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kFMLGraryColor;
    // Do any additional setup after loading the view.
    
    //筛选
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-70, 20, 35, NavigationBarH-20)];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    UIBarButtonItem *itemBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    if (self.controllType == JMViewControllerBalance) {
        
        self.title = @"余额明细";
        self.navigationItem.rightBarButtonItem=itemBtn;
        
    }
    else
    {
        self.title = @"提现历史";
    }
    
    [self addSubViews];
    
}

#pragma mark - 搭建页面
-(void)addSubViews{
    //创建tabview
    UITableView *tv=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tv.delegate=self;
    tv.dataSource=self;
    tv.separatorColor = kFMDLineGraryColor;
    [self.view addSubview:tv];
    _tv=tv;
    
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    //提前注册
    [tv registerNib:[UINib nibWithNibName:@"FMBalanceDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:[FMBalanceDetailsTableViewCell identifier]];
    
    //自定义头部刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(balanceListHeaderBeganRefresh)];
    // 设置header
    _tv.mj_header=[XHView customTopHeaderWithHearder:header];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(balanceListFooterBeganRefresh)];
    _tv.mj_footer=footer;
    
    [footer setTitle:@"已无更多数据" forState:MJRefreshStateNoMoreData];
    
    
    [self initBalanceRecordsDataWithPageNum:_pageNum];
}
-(void)initBalanceRecordsDataWithPageNum:(NSInteger)pageNum{
    
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url;
    NSInteger offset = _pageNum*15;
    NSDictionary *dict;
    if (self.controllType == JMViewControllerBalance) {
        url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kBALANCERECORDS];
        //非必须字段 -3: 违约金 -2: 充值押金 -1: 提现 1: 配送收入 2: 押金转余额

        if(_recordsNum == 0)
        {
   
            //全部
    
            dict = @{
             
                     @"limit":@15,
                     @"offset":[NSString stringWithFormat:@"%ld",offset]
            
                     };

        }
        else
        {
            dict = @{
                     
                     @"limit":@15,
                     @"offset":[NSString stringWithFormat:@"%ld",offset],
                     @"type":[NSString stringWithFormat:@"%ld",_recordsNum]
    
                     };
        }
        
    }
    else
    {
        url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kBALANCERECORDS];
        dict = @{
                 @"limit":@15,
                 @"offset":[NSString stringWithFormat:@"%ld",offset],
                 @"type":@-1
                 };
    }
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        FMBalanceJsonModeal *jsonModel= [[FMBalanceJsonModeal alloc]initWithDictionary:returnValue error:&error];
        
        if (offset == 0) {
            self.jsonModel = jsonModel;
            
        }else {
            [self.jsonModel.data addObjectsFromArray:(NSArray*)jsonModel.data];
        }

        if (jsonModel.data.count<15) {
            //结束头部刷新
            [_tv.mj_header endRefreshing];
            [_tv.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            //结束头部刷新
            [_tv.mj_header endRefreshing];
            [_tv.mj_footer endRefreshing];
        }
        
        [_tv reloadData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        
        //结束头部刷新
        [_tv.mj_header endRefreshing];
        [_tv.mj_footer endRefreshing];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
        
    } WithFailureBlock:^{
        
        //结束头部刷新
        [_tv.mj_header endRefreshing];
        [_tv.mj_footer endRefreshing];
        
    }];

}
#pragma mark delegate && dataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.jsonModel.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMBalanceDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[FMBalanceDetailsTableViewCell identifier]];
    FMBalanceModel *model = self.jsonModel.data[indexPath.section];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
//    backGroundView.backgroundColor = kFMLGraryColor;
//    
//    //日期
//    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth/2, 25)];
//    dateLabel.font = [UIFont systemFontOfSize:14.0f];
//    dateLabel.text = @"2016-12";
//    [backGroundView addSubview:dateLabel];
//    
//    //支出，收入
//    UILabel *detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(dateLabel.frame), ScreenWidth/2, 25)];
//    detailsLabel.textColor = kFMWordGrayColor;
//    detailsLabel.font = k12SizeFont;
//    detailsLabel.text = @"支出¥75.44";
//    [backGroundView addSubview:detailsLabel];
//    
//    //日历
//    UIButton *calendarBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-45, 10, 30, 30)];
//    [calendarBtn setImage:[UIImage imageNamed:@"content_icon_rli"] forState:UIControlStateNormal];
//    [calendarBtn addTarget:self action:@selector(calendarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [backGroundView addSubview:calendarBtn];
//    
//    
//    
//    return backGroundView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入下一个页面
    FMBalanceDescribeViewController *vc = [[FMBalanceDescribeViewController alloc]init];
    FMBalanceModel *model = self.jsonModel.data[indexPath.section];
    vc.balanceId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - 响应事件

-(void)calendarBtnClicked
{
    _pickerYearData = [NSMutableArray arrayWithCapacity:0];
    [_pickerYearData addObject:@"2016"];
    [_pickerYearData addObject:@"2017"];
    [_pickerYearData addObject:@"2018"];
    
    _pickerMonthData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.layer.contents = (__bridge id) [UIImage imageNamed:@"fdbeij"].CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:view];
    _calendarViewLayer = view;
    [[UIApplication sharedApplication].keyWindow addSubview:_calendarViewLayer];

    //日期选择器后面的背景view
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-290)/2, (ScreenHeight-200)/2, 290, 240)];
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.layer.cornerRadius = 3.0f;
    dateView.clipsToBounds = YES;

    [view addSubview:dateView];
    
    //被选中的日期
    UILabel *selectedDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth, 40)];
    selectedDataLabel.font = [UIFont systemFontOfSize:14.0f];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    _yearStr = [NSString stringWithFormat:@"%ld",(long)date.year];
    _monthStr = [NSString stringWithFormat:@"%ld",(long)date.month];;
    NSString *dateStr = [dateFormatter stringFromDate:date];

    selectedDataLabel.text = [NSString stringWithFormat:@"%@",dateStr];
    [dateView addSubview:selectedDataLabel];
    _selectedDataLabel = selectedDataLabel;
    //
    
    //日期选择器
    self.datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 290, 120)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    self.datePicker.layer.borderColor = kFMLLineGraryColor.CGColor;
    self.datePicker.layer.borderWidth = 0.5f;
    
    [dateView addSubview:self.datePicker];
    
    //取消
    UIButton *cancelBtn = [XHView createBtnWithFrame:CGRectMake(0, CGRectGetMaxY(self.datePicker.frame), 145, 40) text:@"取消" textColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] setImgName:nil target:self action:@selector(cancelBtnClicked) superView:dateView];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
////    cancelBtn.titleLabel.text = @"取消";
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [dateView addSubview:cancelBtn];
    
    //lineView
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(self.datePicker.frame), 0.5, 40)];
    lineView.backgroundColor = kFMDLineGraryColor;
    [dateView addSubview:lineView];
    
    //确认
    UIButton *certainBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+1, CGRectGetMaxY(self.datePicker.frame), 145, 40)];
    [certainBtn setTitle:@"确认" forState:UIControlStateNormal];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [certainBtn setTitleColor:kFMBlueColor forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(certainBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:certainBtn];

}

#pragma mark - 实现协议UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _pickerYearData.count;
    }
    else
    {
        return _pickerMonthData.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_pickerYearData objectAtIndex:row];
    }
    else
    {
        return [_pickerMonthData objectAtIndex:row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _yearStr = [_pickerYearData objectAtIndex:row];
        _selectedDataLabel.text = [NSString stringWithFormat:@"%@年%@月",_yearStr,_monthStr];
    }
    else
    {
        _monthStr = [_pickerMonthData objectAtIndex:row];
        _selectedDataLabel.text = [NSString stringWithFormat:@"%@年%@月",_yearStr,_monthStr];
    }
}
-(void)cancelBtnClicked
{
    [_calendarViewLayer removeFromSuperview];
}
-(void)certainBtnClicked
{
    [_calendarViewLayer removeFromSuperview];
}
-(void)filterBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
    }];
    
}
//筛选
-(void)selectBtnClicked
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.layer.contents = (__bridge id) [UIImage imageNamed:@"fdbeij"].CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:view];
    _filterViewLayer = view;
    [[UIApplication sharedApplication].keyWindow addSubview:_filterViewLayer];

    //谈框
    FMTransactionView *transactionView = [[[NSBundle mainBundle] loadNibNamed:@"FMTransactionView" owner:self options:nil]lastObject];
    transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
    transactionView.backgroundColor = [UIColor whiteColor];
    transactionView.clipsToBounds = YES;
    
    //全部
    [transactionView.allBtn addTarget:self action:@selector(allBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //配送收入
     [transactionView.distributionInBtn addTarget:self action:@selector(distributionInBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //提现
     [transactionView.withdrawBtn addTarget:self action:@selector(witrawBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //充值金
     [transactionView.rechargeBtn addTarget:self action:@selector(rechargeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //押金转余额
     [transactionView.transferBtn addTarget:self action:@selector(transferBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //扣违约金
     [transactionView.deductionBtn addTarget:self action:@selector(deductionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_filterViewLayer addSubview:transactionView];
    _transactionView = transactionView;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(transactionView.frame)+10, ScreenWidth, 45)];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(transactionView.frame)+10, ScreenWidth, 45);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kFMBlackColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(filterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_filterViewLayer addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
    
    [UIView animateWithDuration:0.5 animations:^{
       
        transactionView.frame = CGRectMake(0, ScreenHeight-295, ScreenWidth, 240);
        cancelBtn.frame = CGRectMake(0, ScreenHeight-45, ScreenWidth, 45);
    }];
    
    
    
}
#pragma mark -  刷新
-(void)balanceListHeaderBeganRefresh
{
    _pageNum = 0;
    [self initBalanceRecordsDataWithPageNum:_pageNum];
}
-(void)balanceListFooterBeganRefresh
{
    _pageNum++;
    [self initBalanceRecordsDataWithPageNum:_pageNum];
}
//全部
-(void)allBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
        _pageNum = 0;
        _recordsNum = 0;
        [self initBalanceRecordsDataWithPageNum:_pageNum];

    }];

    
}
//配送收入
-(void)distributionInBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
        _pageNum = 0;
        _recordsNum = 1;
        [self initBalanceRecordsDataWithPageNum:_pageNum];
    }];
    
}
//提现
-(void)witrawBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
        _pageNum = 0;
        _recordsNum = -1;
        [self initBalanceRecordsDataWithPageNum:_pageNum];
    }];
   
}
//充值金
-(void)rechargeBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
        _pageNum = 0;
        _recordsNum = -2;
        [self initBalanceRecordsDataWithPageNum:_pageNum];
    }];
    
}
//押金转余额
-(void)transferBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
        _pageNum = 0;
        _recordsNum = 2;
        [self initBalanceRecordsDataWithPageNum:_pageNum];
    }];
    
}
//扣违约金
-(void)deductionBtnClicked
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _transactionView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_transactionView.frame)+10, ScreenWidth, 45);
        
    } completion:^(BOOL finished) {
        [_filterViewLayer removeFromSuperview];
        _pageNum = 0;
        _recordsNum = -3;
        [self initBalanceRecordsDataWithPageNum:_pageNum];
    }];
    
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
