//
//  FMLoginViewController.m
//  FlashMan
//
//  Created by dianda on 2017/1/5.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMLoginViewController.h"
#import <JKCountDownButton.h>
#import "FMGuildViewController.h"
#import "SSKeychain.h"
@interface FMLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userPhoneT;
@property (weak, nonatomic) IBOutlet UITextField *codeT;
//倒计时
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendMsgButton;

@property (weak, nonatomic) IBOutlet UIView *phoneNumberBgView;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@end

@implementation FMLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.xieyiLabel.hidden = YES;
    self.describeLabel.text = @"";
    if (_type == FMLoginTypeLogin) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *logInBtn = [XHView createBtnWithFrame:CGRectMake(10, 10, ScreenWidth-20, 45) text:@"登录" textColor:kFMWhiteColor backgroundColor:kFMBlueColor setImgName:nil target:self action:@selector(logBtnClicked) superView:view];
        logInBtn.layer.cornerRadius = 3.0f;
        logInBtn.clipsToBounds = YES;
        
        self.tableView.tableFooterView = view;
        self.navigationItem.title = @"登录";
        self.describeLabel.text = @"注：同一手机号只能登录一个账号";
    }else {
        self.navigationItem.title = @"注册";
        self.describeLabel.text = @"注：同一手机号只能注册一个账号";
        self.registeredBtn.layer.cornerRadius = 3.0f;
        self.registeredBtn.clipsToBounds = YES;
        [self.registeredBtn addTarget:self action:@selector(registeredBtnClicekd) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    self.sendMsgButton.layer.cornerRadius = 3.0f;
    self.sendMsgButton.clipsToBounds = YES;
    [self.sendMsgButton setTitleColor:kFMRedColor forState:UIControlStateNormal];
    [self.sendMsgButton setBackgroundColor:kFMLGraryColor];
    
    self.codeBgView.layer.cornerRadius = 2.0f;
    self.codeBgView.layer.masksToBounds = YES;
    self.phoneNumberBgView.layer.cornerRadius = 2.0f;
    self.phoneNumberBgView.layer.masksToBounds = YES;

    
    [self.sendMsgButton addTarget:self action:@selector(sendsSMS:) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - delegate && dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == FMLoginTypeLogin) {
        return 2;
    }
    else
    {
        return 3;
    }
}
#pragma mark - 响应事件
//获取验证码按钮被点击
- (void)sendsSMS:(JKCountDownButton *)sender {
    
    if (self.userPhoneT.text == nil || [self.userPhoneT.text isEqualToString:@""]) {
        [XHView showTipHud:@"请输入手机号" superView:self.view];
    }else{
        
        [self getCodeStr];
        sender.enabled = NO;
        [sender startCountDownWithSecond:60];
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"%zds",second];
            return title;
        }];
        
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"重新获取验证码";
        }];
        
    }
}
//获取验证码数据请求
-(void)getCodeStr{
    NetRequestClass *netrequest =  [[NetRequestClass alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kSENDCODE];
    NSDictionary *dict = @{
                           @"phone":self.userPhoneT.text
                           };
    [AppUtils showWithStatus:nil];
    [netrequest NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
    }];
    

}
//登录按钮被点击（包括网络请求）
-(void)logBtnClicked
{
    
    if (self.codeT.text  == nil || [self.codeT.text  isEqual: @""]||self.userPhoneT.text == nil || [self.userPhoneT.text isEqualToString:@""]) {
        
        [XHView showTipHud:@"请输入完整的手机号和验证码" superView:self.view];
    }
    else
    {
        //手机号码格式验证
        BOOL b = [Helper justMobile:self.userPhoneT.text];
        
        if (self.codeT.text.length != 6 || b == NO) {
            if (b == NO) {
                
               [XHView showTipHud:@"手机格式错误" superView:self.view];
            }
            else
            {
                [XHView showTipHud:@"验证码错误" superView:self.view];
            }
        }
        else
        {
            [AppUtils showWithStatus:@"正在登录"];
            NetRequestClass *netrequest =  [[NetRequestClass alloc]init];
            
            NSDictionary *dict = @{
                                   @"phone":self.userPhoneT.text,
                                   @"validateCode":self.codeT.text
                                   };
            
            [netrequest getTokenWithParamas:dict withTimes:3  returnBlack:^(id returnValue) {
                [AppUtils dismissHUD];
                if ([returnValue[kTAG] isEqualToString:kSUCCESS]) {
                    
                    [GVUserDefaults standardUserDefaults].phoneNum = self.userPhoneT.text;
                    NSDictionary *data = returnValue[@"data"];
                    [UserDefaultsUtils saveValue:data[@"token"] forKey:kToken];
                    
                    self.describeLabel.text = @"登录成功";
                    //登录成功
                    [XHView showTipHud:@"登录成功" superView:self.view];
                    //登录成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logInSuccess" object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                }
                else {
                    [AppUtils showErrorMessage:returnValue[@"message"]];
                }
            }];

        }
        

    }

}

//注册按钮被点击（包括数据请求）
-(void)registeredBtnClicekd
{
    if (self.codeT.text  == nil || [self.codeT.text  isEqual: @""]||self.userPhoneT.text == nil || [self.userPhoneT.text isEqualToString:@""]||self.userNameTF.text == nil||[self.userNameTF.text isEqualToString:@""]) {
        
        [XHView showTipHud:@"请输入完整的注册信息" superView:self.view];
    }
    else
    {
        //手机号码格式验证
        BOOL b = [Helper justMobile:self.userPhoneT.text];
        
        if (self.codeT.text.length != 6 || b == NO) {
            if (b == NO) {
                
                [XHView showTipHud:@"手机格式错误" superView:self.view];
            }
            else
            {
                [XHView showTipHud:@"验证码错误" superView:self.view];
            }
        }
        else
        {
            NetRequestClass *netrequest =  [[NetRequestClass alloc]init];
            NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kREGISTER];
            NSDictionary *dict = @{
                                   @"phone":self.userPhoneT.text,
                                   @"validateCode":self.codeT.text,
                                   @"realName":self.userNameTF.text
                                   
                                   };
            [AppUtils showWithStatus:nil];
            [netrequest NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
                [AppUtils dismissHUD];
                
                [GVUserDefaults standardUserDefaults].phoneNum = self.userPhoneT.text;
                NSDictionary *data = returnValue[@"data"];
                [UserDefaultsUtils saveValue:data[@"token"] forKey:kToken];
                
                self.describeLabel.text = @"注册成功";
                //完成注册
                [XHView showTipHud:@"注册成功" superView:self.view];
                
                //登录成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logInSuccess" object:nil];
                //刷新menue账号信息
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            } WithErrorCodeBlock:^(id errorCode) {
                [AppUtils dismissHUD];
                self.describeLabel.text = errorCode[@"message"];
                
            } WithFailureBlock:^{
                [AppUtils dismissHUD];
            }];
            
        }
 
       
    }
        
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
