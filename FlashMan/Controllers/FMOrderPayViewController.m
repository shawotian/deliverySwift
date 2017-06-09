//
//  FMOrderPayViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/16.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMOrderPayViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FMWechatParameterModel.h"
#import "MZTimerLabel.h"
//封装的倒计时view
#import "DDCountdownTimerView.h"
#import "FMMyWalletViewController.h"

@interface FMOrderPayViewController ()<MZTimerLabelDelegate>
//支付宝支付
@property(nonatomic,strong)UIButton *alipayPayBtn;
//微信支付
@property(nonatomic,strong)UIButton *wechatPayBtn;
//支付方式
@property(nonatomic,strong)NSString *payTypeStr;
@property(nonatomic,strong)FMWechatParameterModel *weChatParamterModel;

@property(nonatomic,strong)NSString *tradeRecordNo;

@property(nonatomic,strong)NSString *url;
//倒计时时间
@property(nonatomic,strong)UILabel *countDownLabel;
@property (nonatomic,strong ) MZTimerLabel *timerExample;
@property (nonatomic,strong ) DDCountdownTimerView *daojishiView;
@end

@implementation FMOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kFMLGraryColor;
    
    self.title = @"选择支付方式";
    _payTypeStr = @"alipay";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"paySuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFaile) name:@"payFaile" object:nil];

    [self addSubViews];
    
}
-(void)balancePayData{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kBALANCEPAY];
    NSString *sumStr = [NSString stringWithFormat:@"%.2f",[self.rechargeMoney doubleValue]];
    NSDictionary *dict = @{
                           @"sum":sumStr,
                           @"type":_payTypeStr
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        //支付宝
        if ([_payTypeStr isEqualToString:@"alipay"]) {
            NSDictionary *data = returnValue[@"data"];
            _url = data[@"codeUrl"];
            _tradeRecordNo = data[@"tradeRecordNo"];
            [self doAlipayPay];
        }
        else//微信
        {
            NSError *error = nil;
            
            NSDictionary *appParamsDict = returnValue[@"data"];
            FMWechatParameterModel *jsonModel= [[FMWechatParameterModel alloc]initWithDictionary:appParamsDict[@"appParams"] error:&error];
            
            self.weChatParamterModel = jsonModel;
            [self wechatPay];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        [AppUtils dismissHUD];
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        [XHView showTipHud:@"支付失败" superView:self.view];
        
    }];
    
}
-(void)submitGoodsDataAlipay
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kSUBMITGOODS];
    NSString *sumStr = [NSString stringWithFormat:@"%.2f",[self.rechargeMoney doubleValue]];
    NSDictionary *dict = @{
                           @"ids":self.idsArr,
                               @"payMethod":_payTypeStr,
                               @"paySum":sumStr
                               
                               };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSDictionary *data = returnValue[@"data"];
        _url = data[@"codeUrl"];
        _tradeRecordNo = data[@"tradeRecordNo"];
        [self doAlipayPay];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        [AppUtils dismissHUD];
    } WithFailureBlock:^{
        
        [AppUtils dismissHUD];
        
    }];
    
    
    
}
-(void)submitGoodsDataWechat
{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kSUBMITGOODS];
    NSString *sumStr = [NSString stringWithFormat:@"%.2f",[self.rechargeMoney doubleValue]];
    NSDictionary *dict = @{
                           @"ids":self.idsArr,
                           @"payMethod":_payTypeStr,
                           @"paySum":sumStr
                           
                           };
    [AppUtils showWithStatus:nil];
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        NSError *error = nil;
        NSDictionary *appParamsDict = returnValue[@"data"];
        FMWechatParameterModel *jsonModel= [[FMWechatParameterModel alloc]initWithDictionary:appParamsDict[@"appParams"] error:&error];
        self.weChatParamterModel = jsonModel;
        [self wechatPay];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        [AppUtils dismissHUD];
    } WithFailureBlock:^{
        
        [AppUtils dismissHUD];
        
    }];
}
#pragma mark - 搭建页面
-(void)addSubViews
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    //
    UILabel *moneyLabel = [XHView createLabelWithFrame:CGRectMake(0, 25, ScreenWidth, 30) text:@"剩余支付时间" textColor:kFMBlueColor font:[UIFont systemFontOfSize:20.0f] superView:headerView];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    
    //倒计时时间view－－距离结束时间
    _daojishiView=[[DDCountdownTimerView alloc]initWithFrame:CGRectMake((ScreenWidth-73)/2, 40, 73, 50)];
    [headerView addSubview:_daojishiView];
    //充值金额
    _timerExample = [[MZTimerLabel alloc] initWithView:_daojishiView andTimerType:MZTimerLabelTypeTimer];
    _timerExample.delegate=self;
  
    [_timerExample setCountDownTime:60*30];
    
    [_timerExample start];

    //请选择支付方式
    UILabel *payTypeLabel = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(headerView.frame), ScreenWidth, 35) text:@"请选择支付方式" textColor:kFMWordGrayColor font:[UIFont systemFontOfSize:14.0f] superView:headerView];
    
    //
    UIView *payTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payTypeLabel.frame), ScreenWidth, 90)];
    payTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payTypeView];
    
    //支付宝支付
//    UILabel *leftMoneyLabel = [XHView createLabelWithFrame:CGRectMake(10, 0, ScreenWidth/2, 25) text:@"余额支付（推荐）" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0f] superView:payTypeView];
//    UILabel *leftMoneyDetail = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(leftMoneyLabel.frame), ScreenWidth/2, 20) text:@"当前可用余额不足）" textColor:[UIColor redColor] font:k12SizeFont superView:payTypeView];
    //
    UIImageView *alipayPayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 77, 28)];
    [alipayPayImageView setImage:[UIImage imageNamed:@"logo_zhifubao"]];
    [payTypeView addSubview:alipayPayImageView];
    
    UIButton *alipayPayBtn = [XHView createBtnWithFrame:CGRectMake(ScreenWidth-55, 0, 45, 45) text:nil textColor:nil backgroundColor:nil setImgName:@"content_button_zhifuxuanze_normal" target:self action:@selector(alipayPayBtnClicked) superView:payTypeView];
    [alipayPayBtn setImage:[UIImage imageNamed:@"content_button_zhifuxuanze_pressed"] forState:UIControlStateSelected];
    alipayPayBtn.selected = YES;
    _alipayPayBtn = alipayPayBtn;
    
    
    //line
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(alipayPayImageView.frame)+8, ScreenWidth, 0.5)];
    lineView.backgroundColor = kFMLLineGraryColor;
    [payTypeView addSubview:lineView];
    
    //微信支付
//    UILabel *otherPayLabel = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame), ScreenWidth/2, 25) text:@"其他支付方式）" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0f] superView:payTypeView];
//    UILabel *otherPayDetail = [XHView createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(otherPayLabel.frame), ScreenWidth/2, 20) text:@"如支付宝、微信支付等" textColor:kFMWordGrayColor font:k12SizeFont superView:payTypeView];
    UIImageView *wechatPayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, 97, 26)];
    [wechatPayImageView setImage:[UIImage imageNamed:@"logo_weiixn"]];
    [payTypeView addSubview:wechatPayImageView];
    
    UIButton *wechatPayBtn = [XHView createBtnWithFrame:CGRectMake(ScreenWidth-55, CGRectGetMaxY(lineView.frame), 45, 45) text:nil textColor:nil backgroundColor:nil setImgName:@"content_button_zhifuxuanze_normal" target:self action:@selector(wechatPayClicked) superView:payTypeView];
    [wechatPayBtn setImage:[UIImage imageNamed:@"content_button_zhifuxuanze_pressed"] forState:UIControlStateSelected];
    wechatPayBtn.selected = NO;
    _wechatPayBtn = wechatPayBtn;
    
    //确认支付
    UIButton *certainBtn = [XHView createBtnWithFrame:CGRectMake(10, CGRectGetMaxY(payTypeView.frame)+30, ScreenWidth-20, 45) text:[NSString stringWithFormat:@"确认支付¥%.2f",[self.rechargeMoney doubleValue]] textColor:[UIColor whiteColor] backgroundColor:kFMBlueColor setImgName:nil target:self action:@selector(certainBtnClicked) superView:self.view];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    certainBtn.layer.cornerRadius = 3.0f;
    certainBtn.clipsToBounds = YES;
    
}

#pragma mark - 响应事件
//支付宝支付
-(void)alipayPayBtnClicked{
    _alipayPayBtn.selected = YES;
    _wechatPayBtn.selected = NO;
    _payTypeStr = @"alipay";
}
//微信支付
-(void)wechatPayClicked{
    _alipayPayBtn.selected = NO;
    _wechatPayBtn.selected = YES;
    _payTypeStr = @"wechat";
}
//确认支付
-(void)certainBtnClicked
{
//    if ([_payTypeStr isEqualToString:@"alipay"]) {
//        //支付宝
//        [self doAlipayPay];
//    }
//    else{
//        [self wechatPay];
//    }
    if(self.controllType == JMViewControllerPayTypeRecharge)
    {
        //充值
        [self balancePayData];
        
    }
    else{
        if ([_payTypeStr isEqualToString:@"alipay"]) {
            [self submitGoodsDataAlipay];
        }
        else
        {
            [self submitGoodsDataWechat];
        }
    }
    

}

-(void)wechatPay
{
    //调取微信支付
    PayReq *request = [[PayReq alloc] init];
    //商户号
//    request.partnerId = @"1438983402";
    request.partnerId = self.weChatParamterModel.partnerid;
    request.prepayId= self.weChatParamterModel.prepayid;//有
//    request.package = @"Sign=WXPay";
    request.package = self.weChatParamterModel.package;
    //  随机字符串变量 这里最好使用和安卓端一致的生成逻辑
//    NSString *nonce_str = [self generateTradeNO];
//    request.nonceStr= nonce_str;
    request.nonceStr= self.weChatParamterModel.noncestr;
    //时间戳
    // 将当前时间转化成时间戳
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
//    UInt32 timeStamp =[timeSp intValue];
//    request.timeStamp= timeStamp;
    
    UInt32 timeStamp =[self.weChatParamterModel.timestamp intValue];
    request.timeStamp = timeStamp;
    //签名
//    request.sign= self.weChatParamterModel.tradeRecordNo;
    request.sign = self.weChatParamterModel.sign;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
       [WXApi sendReq:request];
    }
    else
    {
        [XHView showTipHud:@"没有安装微信或者微信版本过低" superView:self.view];
    }
    
}

//-(void)onResp:(BaseResp*)resp{
//    if ([resp isKindOfClass:[PayResp class]]){
//        PayResp*response=(PayResp*)resp;
//        switch(response.errCode){
//                //WXSuccess
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                break;
//            default:
//                NSLog(@"支付失败，retcode=%d",resp.errCode);
//                break;
//        }
//    }
//}
//




#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)doAlipayPay
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017020805567270";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCPt9K0n2yAqKLCdpJGAWQPaUAHbQc/bLjCMj36vW3YFy2+S62qSnHwqVx+kR9QTaEfdqYlLR0/gQICPekJA5CWa+nAfV1pdkuJGf8G+m4+n+7wPvfkqwdnODyJUqfEsRRLOumL+UBmxoN5W4Qe8Ez+iLgT+PHaqX1TeZtklJODEl/1AJaN8gVyj/aBOoUYchwhgk3q9vfThZx78RuGdJs6+t6rKFkUH9LvfR3bmOR6b226AcvyH/Mb/ffX+lHi2jYkHmKT+JzIOFWJsbAhiCXT+OWbihLZc8jZNsKj9jRVMaIlC+EHC6Ej9NrVRkH0xssDJKEe+9sYnzj0MKd0Iu+DAgMBAAECggEBAIhDGMLqeNyPhynrdApt3SoDd5LS29FVyuNM8Zjfq9r7NwK7DCBuTxOH8EuMWu0vfTmwrByJZrbEIVxwyJckSx1jmZBJDJ0mbL3D6Rn7rTUxPEGK4kxroCxMlJD6zlheMMiXRcHSBC6tvw/8JguTeNzIUgeVu/G/SzUvEpdNi4L0HDdVSXTZaPWKALmWllyFiRhZUxG23fqFAWMF7U84xxCPM14YT/am4oHVadbd/39C9mbX14JQTymrXZsakYKRJ0WKX3Y1/DS0Gdf7ASuUh8091J50OdXG8Bxh3ymjcCopzbFKfo6fIFJ+2YqgwKf5VBI782hA2Y+UtDZ4motwifkCgYEA+A4c53Z60+CbNr1UQbxl1Xz6dj9gseWMo0XUxLcFI7xaqaE6fpu+mXvkyd1bVX/QONUD05u6/kQT+2xG0ZlY/BxvuMwT9lZxoQGviDweCWAxmxLTJgsksd24RytO7nk8ItHDJHarIK11QcqPKbvhD81Mt5x0iWdUDSYFmJsnSdUCgYEAlFI3MAH+OqzmidIRDYtrWEnwnmcxPL+weKtjJZ4j3niKIgYrP5LMIb0HakKbcz8moUt0JQeiamGFhTqvh/ZFcWx4NLszspEJdUkyVWtAaWnYyw3VjjVMwzGwDANFIgR5d662etBFJluELMbCiNRK/JEJthFOylOPX44XedVuZ/cCgYA4+pTtHiwMq1U797V4/BuwNGsb6mb9tird/lZncVr+4G8688wJ9SCNBQaC0BQAycE8rMGaQ/VqHp0wbai+0Ki+EJIhMs+LEEQ9pbN6acTEhpIeeu6BmKGvMaz4vBv/b12+6cwXfiLE+NMsb6j+/yctiA0NSCUEwvVtp8Q1T75wmQKBgDSX/rfITSTzQIBoe+GIqZTSCz+wKdZ3xpTTeUHSlLeDmL+93kIZxMbF58Y3PjYck48oWVP0JBSC5jy69ZlJq5AvvWQ9aXSNV4Q+Y1nEwT9f6B8AldRqdADXMqzfz/jjC0t0KYLdLVgPpYvXIw4v8TMkHwRvmLfH75Qbp5ltJEw7AoGBAN05rctfzZOJ5vsaC5k0j2A/PGA3VnmizwLyNSUimSp2zr5901TBe4kpJ+xB7Y1udziX7O4T8CQlGJjyQrqvMOxztCWuu031cDBETmtibLE9Z2pPDILcMd94KLiRZSQgIoq2sfG1+u2lyqjGpnJaalUe/9lYj2GTWi4cZgf4fVyP";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order* order = [Order new];
//    
//    // NOTE: app_id设置
//    order.app_id = appID;
//    
//    // NOTE: 支付接口名称
//    order.method = @"alipay.trade.app.pay";
//    
//    // NOTE: 参数编码格式
//    order.charset = @"utf-8";
//    
//    // NOTE: 当前时间点
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    order.timestamp = [formatter stringFromDate:[NSDate date]];
//    
//    // NOTE: 支付版本
//    order.version = @"1.0";
//    
//    // NOTE: sign_type 根据商户设置的私钥来决定
//    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
//    
//    // NOTE: 商品数据
//    order.biz_content = [BizContent new];
//    order.biz_content.body = @"我是测试数据";
//    order.biz_content.subject = @"1";
//    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.biz_content.timeout_express = @"30m"; //超时时间设置
//    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
//    
//    //将商品信息拼接成字符串
//    NSString *orderInfo = [order orderInfoEncoded:NO];
//    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
//    
//    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
//    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    NSString *signedString = nil;
//    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
//    if ((rsa2PrivateKey.length > 1)) {
//        signedString = [signer signString:orderInfo withRSA2:YES];
//    } else {
//        signedString = [signer signString:orderInfo withRSA2:NO];
//    }
//    
//    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil) {
//        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"flashalisdkdemo";
//        
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
//
//    NSString *orderString = @"";
        // NOTE: 调用支付结果开始支付(没有安装支付宝客户端的情况)
        [[AlipaySDK defaultService] payOrder:_url fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            
            NSNumber *resultStatus = resultDic[@"resultStatus"];
            switch ([resultStatus integerValue]) {
                    case 9000:
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                    
                    break;
                    
                default:
                    //发送失败的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payFaile" object:resultStatus];
                    break;
            }

        
            
        }];
//    }
}

-(void)paySuccess
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"支付结果"
                                                                   message:@"支付结果：成功！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          FMMyWalletViewController *vc = [[FMMyWalletViewController alloc]init];
                                                          
                                                          FMNavigationController *nav =   (FMNavigationController *) self.frostedViewController.contentViewController ;
                                                          [nav popToRootViewControllerAnimated:NO];
                                                          [nav pushViewController:vc animated:NO];
                                                      }];
    
    [alert addAction:delAction];
    [self presentViewController:alert animated:YES completion:nil];


}
-(void)payFaile
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"支付结果"
                                                                   message:@"支付结果：失败！"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          //
                                                      }];
    
    [alert addAction:delAction];
    [self presentViewController:alert animated:YES completion:nil];
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
