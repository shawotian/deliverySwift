//
//  FMMyTaskPageViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/17.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMMyTaskPageViewController.h"
#import "FMHomeOrderCell.h"
#import "FMOrderDetailController.h"
#import "FMOrderListJsonModel.h"
#import "DDScanViewController.h"
#import "DDQRCodeViewController.h"
#import "FMCertainSendArrivedView.h"
#import "FMQRCodePayTypeViewController.h"
#import "FMArrivedModel.h"
static NSString *const HOMEORDERCELL = @"FMHomeOrderCell";
@interface FMMyTaskPageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
//分页加载标记
@property(nonatomic,assign)NSInteger pageNum;
//数据源
@property(nonatomic,strong)FMOrderListJsonModel *jsonModel;
//当前操作的model
@property(nonatomic,strong)FMOrderModel *model;
@property(nonatomic,strong)UIView *acceptViewLayer;
//1：送达，0:拒收
@property(nonatomic,strong)NSNumber *typeState;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)FMCertainSendArrivedView *transactionView;
@property(nonatomic,strong)NSString *payTypeStr;

//付款方式按钮数组
@property(nonatomic,strong)NSMutableArray *payTypeBtnArr;
@property(nonatomic,strong)FMArrivedModel *arrivedModel;

@end

@implementation FMMyTaskPageViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _pageNum = 0;
    [self initDataWithPageNum:_pageNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = kFMLLineGraryColor;
    
    [self addSubViews];
    
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

    
    [self initDataWithPageNum:_pageNum];
}
#pragma mark - 请求数据
-(void)initDataWithPageNum:(NSInteger)pageNum{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kORDERLISTSTATE];

    NSInteger offset = pageNum*15;
    NSNumber *orderState;
    //待取货
    if (self.controllType == JMViewControllerToBePickedUp){
        orderState = @1;
    }//配送中
    else if (self.controllType == JMViewControllerDelivery)
    {
        orderState = @2;
    }//返还中订单
    else if (self.controllType == JMViewControllerReturning)
    {
        orderState = @3;
    }
    else
    {
        orderState = @4;
    }
    

    NSDictionary *dict = @{
                           @"state":orderState
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        FMOrderListJsonModel *jsonModel= [[FMOrderListJsonModel alloc]initWithDictionary:returnValue error:&error];
        NSLog(@"%@",jsonModel);
        if (offset == 0) {
            self.jsonModel = jsonModel;
            
        }else {
            [self.jsonModel.data addObjectsFromArray:(NSArray*)jsonModel.data];
        }
        if (jsonModel.data.count == 0) {
            [XHView showTipHud:@"已加载全部数据" superView:self.view];
        }
      
        //结束头部刷新
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
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
#pragma mark - 送达接口
-(void)arrivedGoodsDataWithNumberId:(NSString *)numberId WithReceiptCode:(NSString *)receiptCode WithTypeType:(NSString *)payType{
    
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kSENDARRIVED];

    NSDictionary *dict = @{
                           @"numberId":numberId,
                           @"receiptCode":receiptCode,
                           @"receiveType":payType
                           
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        FMArrivedModel * arrivedModel = [[FMArrivedModel alloc]initWithDictionary:returnValue[@"data"] error:&error];
        self.arrivedModel = arrivedModel;

        [_acceptViewLayer removeFromSuperview];
        
        FMQRCodePayTypeViewController *vc = [[FMQRCodePayTypeViewController alloc]init];
        //已经在线支付的情况
        if([_payTypeStr isEqualToString:@"cash"])
        {
            [XHView showTipHud:@"已确认送达！" superView:self.view];
        }
        else
        {
            vc.codeUrl =_arrivedModel.codeUrl;
            vc.payId = _arrivedModel.payId;
            vc.orderId = self.model.OrderId;
            vc.moneyNum = self.model.orderAmount;
            
            //微信支付
            if ([_payTypeStr isEqualToString:@"wepay"]) {
                vc.payType = SMViewControllerWeChatPay;
            }
            else//支付宝支付
            {
                vc.payType = SMViewControllerWeAlipyPay;
            }
            REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];
        }

        
        //刷新列表
        [self orderListHeaderBeganRefresh];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
        
        
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
       
        [_acceptViewLayer removeFromSuperview];
            //送达
        [XHView showTipHud:@"送达失败" superView:self.view];
     
        
        
    }];
    
    
}
//拒收接口
-(void)rejectGoodsDataWithNumberId:(NSString *)numberId WithReceiptCode:(NSString *)receiptCode WithTypeState:(NSNumber *)typeState{
    
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kREJECTGOODS];
    
    NSDictionary *dict = @{
                           @"numberId":numberId,
                           @"receiptCode":receiptCode
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        //拒收
        [XHView showTipHud:@"拒收成功" superView:self.view];
        //刷新列表
        [self orderListHeaderBeganRefresh];
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[kMESSAGE] superView:self.view];
        
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        //拒收
        [XHView showTipHud:@"拒收失败" superView:self.view];

        
    }];
    
    
}

#pragma mark - tableView delegate && dataSource
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45.0f;
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
    
    
    //待取货
    if (self.controllType == JMViewControllerToBePickedUp) {
       
        UIButton *scanbtn = [XHView createBtnWithFrame:CGRectMake(0, 0, ScreenWidth-20, 45) text:@"扫描二维码" textColor:kFMBlueColor backgroundColor:[UIColor whiteColor] setImgName:nil target:self action:@selector(scanbtnClicked:) superView:whiteView];
        scanbtn.tag = section + 1000;
        scanbtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        
    }//配送中
    else if (self.controllType == JMViewControllerDelivery)
    {
        UIButton *arriveBtn = [XHView createBtnWithFrame:CGRectMake(0, 0, (ScreenWidth-20)/2, 45) text:@"送达" textColor:kFMBlueColor backgroundColor:[UIColor whiteColor] setImgName:nil target:self action:@selector(arriveBtnClicked:) superView:whiteView];
        arriveBtn.tag = section + 1000;
        arriveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UIButton *rejectBtn = [XHView createBtnWithFrame:CGRectMake(CGRectGetMaxX(arriveBtn.frame)+1, 0, (ScreenWidth-20)/2, 45) text:@"拒收" textColor:kFMBlueColor backgroundColor:[UIColor whiteColor] setImgName:nil target:self action:@selector(rejectBtnClicked:) superView:whiteView];
        rejectBtn.tag = section + 500;
         rejectBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];

    }//返还中订单
    else if (self.controllType == JMViewControllerReturning)
    {
        UIButton *returnBtn = [XHView createBtnWithFrame:CGRectMake(0, 0, ScreenWidth-20, 45) text:@"出示二维码" textColor:kFMBlueColor backgroundColor:[UIColor whiteColor] setImgName:nil target:self action:@selector(returnBtnClicked:) superView:whiteView];
        returnBtn.tag = section + 1500;
        returnBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
    }//更多
    else
    {
        
    }
    
    return backGroundView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMOrderDetailController *orderD = [[FMOrderDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    FMOrderModel *model = self.jsonModel.data[indexPath.section];
    orderD.orderID = model.id;
    //待取货
    if (self.controllType == JMViewControllerToBePickedUp){
        orderD.controllType = JMViewControllerToBePickedUpDetail;

    }
    //配送中
    else if (self.controllType == JMViewControllerDelivery)
    {
        orderD.controllType = JMViewControllerDeliveryDetail;
    }
    //返还中订单
    else if (self.controllType == JMViewControllerReturning)
    {
        orderD.controllType = JMViewControllerReturningDetail;
    }
    else{
        
    }
    
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] pushViewController:orderD animated:YES];
    
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 响应事件
//是否确认绝收？
-(void)isCertainRejectView
{
    
    _payTypeBtnArr = [NSMutableArray arrayWithCapacity:0];
    _payTypeStr = @"";
//    _codeTFStr = @"";
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.layer.contents = (__bridge id) [UIImage imageNamed:@"fdbeij"].CGImage;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:view];
    _acceptViewLayer = view;
    [[UIApplication sharedApplication].keyWindow addSubview:_acceptViewLayer];
    
    //谈框
    FMCertainSendArrivedView *transactionView = [[[NSBundle mainBundle] loadNibNamed:@"FMCertainSendArrivedView" owner:self options:nil]lastObject];
    transactionView.frame = CGRectMake((ScreenWidth-300
                                        )/2, (ScreenHeight-380)/2, 300, 380);
    transactionView.backgroundColor = [UIColor whiteColor];
    transactionView.clipsToBounds = YES;
    transactionView.layer.cornerRadius = 3.0f;
    transactionView.codeTF.delegate = self;
    self.codeTF = transactionView.codeTF;
    if([_typeState integerValue]==0)
    {
        //拒收
        transactionView.titleBtn.text = @"是否确认拒收？";
        transactionView.frame = CGRectMake((ScreenWidth-280)/2, (ScreenHeight-180)/2, 280, 180);
        transactionView.typeTextLabrl.hidden = YES;
        transactionView.cashBackgroundView.hidden = YES;
        transactionView.wechatBackgroundView.hidden = YES;
        transactionView.alipyBackgroundView.hidden = YES;
        
    }
    else
    {
        //已经支付
        if ([self.model.hasPay integerValue] == 1 ){
            self.payTypeStr = @"cash";
            transactionView.frame = CGRectMake((ScreenWidth-280)/2, (ScreenHeight-180)/2, 280, 180);
            transactionView.typeTextLabrl.hidden = YES;
            transactionView.cashBackgroundView.hidden = YES;
            transactionView.wechatBackgroundView.hidden = YES;
            transactionView.alipyBackgroundView.hidden = YES;

        }
        else
        {
            self.payTypeStr = @"cash";
            transactionView.cashBtn.selected = YES;
            
            [_payTypeBtnArr addObject:transactionView.cashBtn];
            [_payTypeBtnArr addObject:transactionView.wechatBtn];
            [_payTypeBtnArr addObject:transactionView.alipyBtn];
            
            transactionView.titleBtn.text = @"是否确认送达？";
            
            [transactionView.cashBtn addTarget:self action:@selector(cashBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [transactionView.wechatBtn addTarget:self action:@selector(wechatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [transactionView.alipyBtn addTarget:self action:@selector(alipyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        }
        
    }
    [transactionView.cancelBtn addTarget:self action:@selector(ccancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [transactionView.certainBtn addTarget:self action:@selector(ccertainBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_acceptViewLayer addSubview:transactionView];

    _transactionView = transactionView;
    
    

}
-(void)cashBtnClicked:(UIButton*)btn
{
    self.payTypeStr = @"cash";
    btn.selected = YES;
    
    UIButton *wechatBtn = _payTypeBtnArr[1];
    wechatBtn.selected = NO;
    UIButton *alipayBtn = _payTypeBtnArr[2];
    alipayBtn.selected = NO;
    
    
}
-(void)wechatBtnClicked:(UIButton*)btn
{
    self.payTypeStr = @"wepay";
    btn.selected = YES;
    
    UIButton *cashBtn = _payTypeBtnArr[0];
    cashBtn.selected = NO;
    UIButton *alipayBtn = _payTypeBtnArr[2];
    alipayBtn.selected = NO;
}
-(void)alipyBtnClicked:(UIButton*)btn
{
    self.payTypeStr = @"alipay";
    btn.selected = YES;
    
    UIButton *cashBtn = _payTypeBtnArr[0];
    cashBtn.selected = NO;
    UIButton *wecahtBtn = _payTypeBtnArr[1];
    wecahtBtn.selected = NO;
}
//扫描二维码
-(void)scanbtnClicked:(UIButton*)btn
{
    NSInteger sectionNum = btn.tag - 1000;
    FMOrderModel *model = self.jsonModel.data[sectionNum];
    self.model = model;
    
    DDScanViewController *vc = [[DDScanViewController alloc]init];
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];
    



}
//送达
-(void)arriveBtnClicked:(UIButton*)btn
{
    NSInteger sectionNum = btn.tag - 1000;
    FMOrderModel *model = self.jsonModel.data[sectionNum];
    self.model = model;
    self.typeState = [NSNumber numberWithInteger:1];
    
    [self isCertainRejectView];

}
//拒收
-(void)rejectBtnClicked:(UIButton*)btn
{
   
    NSInteger sectionNum = btn.tag - 500;
    FMOrderModel *model = self.jsonModel.data[sectionNum];
    self.model = model;
    self.typeState = [NSNumber numberWithInteger:0];
    
    [self isCertainRejectView];

    
    
}
//弹框 － 取消按钮

-(void)ccancelBtnClicked{
    [_acceptViewLayer removeFromSuperview];
}
//弹框 － 确认按钮
-(void)ccertainBtnClicked {
    
    
    if ([self.codeTF.text isEqualToString:@""] ||self.codeTF.text == nil) {
        
        [XHView showTipHud:@"请输入收获码" superView: [UIApplication sharedApplication].keyWindow];
    }
    else
    {
        
        
        [_acceptViewLayer removeFromSuperview];
        
        if ([self.typeState integerValue]==0) {
            
            //拒收
            [self rejectGoodsDataWithNumberId:self.model.numberId WithReceiptCode:self.codeTF.text WithTypeState:self.typeState];
           
        }
        else
        {
            
            if ([self.payTypeStr isEqualToString:@""] ||self.payTypeStr == nil)
            {
                
                [XHView showTipHud:@"请选择付款方式" superView:[UIApplication sharedApplication].keyWindow];
               
            }
            else
            {
                //送达
                [self arrivedGoodsDataWithNumberId:self.model.numberId WithReceiptCode:self.codeTF.text WithTypeType:self.payTypeStr];
                }
                
            }
        
    }
   
}
//返还中订单按钮被点击
-(void)returnBtnClicked:(UIButton*)btn
{
    NSInteger sectionNum = btn.tag - 1500;
    FMOrderModel *model = self.jsonModel.data[sectionNum];
    self.model = model;
    
    DDQRCodeViewController *vc = [[DDQRCodeViewController alloc]init];
//    vc.numberId = model.numberId;
    vc.orderId = model.id;
    vc.rejectCode = model.rejectCode;
    REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];

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
