//
//  FMWithDrawSettingViewController.m
//  FlashMan
//
//  Created by 小河 on 17/2/14.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMWithDrawSettingViewController.h"
#import "FMWithDrawSettingTableViewCell.h"
#import "FMAlipyMessageModel.h"
#import "FMApplicationWithdrawViewController.h"
#import "FMSettingAlipayViewController.h"
#import "FMAlipyMessageJsonModel.h"
@interface FMWithDrawSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)FMAlipyMessageJsonModel *alipyMessageJsonModel;
//1:有支付宝账号，0:没有支付宝账号
@property(nonatomic,strong)NSNumber *isHaveAlipyNum;

@end

@implementation FMWithDrawSettingViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_tv setEditing:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSetting) name:@"updateSetting" object:nil];
    // Do any additional setup after loading the view.
    self.title = @"提现设置";
    self.view.backgroundColor = kFMLLineGraryColor;
    [self addSubViews];
}
-(void)updateSetting
{
    if (_controllType == JMViewControllerAlipyTypeRecharge) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       [self judgeIsHaveAlipayNumber];
    }
    
}
-(void)addSubViews{
    //创建tabview
    UITableView *tv=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    tv.backgroundColor = kFMLLineGraryColor;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.delegate=self;
    tv.dataSource=self;
    [self.view addSubview:tv];
    _tv=tv;
    
    //提前注册
    [_tv registerNib:[UINib nibWithNibName:@"FMWithDrawSettingTableViewCell" bundle:nil] forCellReuseIdentifier:[FMWithDrawSettingTableViewCell identifier]];
  
    if(self.controllType == JMViewControllerAlipyTypeRecharge)
    {
        //从申请提现页面过来的
        _isHaveAlipyNum = @0;
        
    }
    else
    {
        [self judgeIsHaveAlipayNumber];
    }
    
    
}
//判断当前手机号有没有绑定支付宝账号
-(void)judgeIsHaveAlipayNumber
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kCHECKPHONEALIPAY];
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        NSError *error = nil;
        FMAlipyMessageJsonModel *jsonModel= [[FMAlipyMessageJsonModel alloc]initWithDictionary:returnValue error:&error];
        self.alipyMessageJsonModel = jsonModel;
        if (jsonModel.data.count>0) {
            _isHaveAlipyNum = @1;
        }
        
        [_tv reloadData];
     
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
//        [self settingAlipayTanKuang];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
//        [self settingAlipayTanKuang];
    }];
    
}
//删除支付宝账号
-(void)deleteAlipyNum
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kDELETEALIPYNUM];
    FMAlipyMessageModel *model = self.alipyMessageJsonModel.data[0];
    NSDictionary *dict = @{
                           @"id":model.id
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        _isHaveAlipyNum = @0;
        [_tv reloadData];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:@"删除支付宝失败" superView:self.view];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        [XHView showTipHud:@"删除支付宝失败" superView:self.view];
        
    }];

}

#pragma mark delegate && dataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return _isHaveAlipyNum.integerValue == 1 ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMWithDrawSettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[FMWithDrawSettingTableViewCell identifier]];
    
    if (!cell) {
        cell  =[[[ NSBundle mainBundle] loadNibNamed:@"FMWithDrawSettingTableViewCell" owner:self options:nil] lastObject];
    }

    if (self.alipyMessageJsonModel.data.count>0) {
        FMAlipyMessageModel *model = self.alipyMessageJsonModel.data[indexPath.row];
        cell.alipyMessageModel = model;
    }
    
    //如果已经绑定了支付宝账号
    if ([_isHaveAlipyNum integerValue]==1) {
        
        cell.addWithDrawLabel.hidden = YES;
        
        cell.alipyImage.hidden = NO;
        cell.alipyLabel.hidden = NO;
        cell.alipyNumLabel.hidden = NO;
        
    }
    else
    {
        cell.addWithDrawLabel.hidden = NO;
        
        cell.alipyImage.hidden = YES;
        cell.alipyLabel.hidden = YES;
        cell.alipyNumLabel.hidden = YES;
    }
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //进入下一个页面
    //如果已经绑定了支付宝账号
    if ([_isHaveAlipyNum integerValue]==1)
    {
        if (_controllType == JMViewControllerAlipyTypeSetting) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"是否删除该支付宝？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self deleteAlipyNum];
                                                                  
                                                                  
                                                              }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                       
                                                                  
                                                              }];
            
            [alert addAction:delAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            

        }
        else
        {
            //如果当前手机号绑定了支付宝
            //提现
            FMApplicationWithdrawViewController *vc = [[FMApplicationWithdrawViewController alloc]init];
            FMAlipyMessageModel *model = self.alipyMessageJsonModel.data.firstObject;
            vc.leftMoney = self.balaceMoney;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        FMSettingAlipayViewController *vc = [[FMSettingAlipayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
