//
//  FMQRCodePayTypeViewController.m
//  FlashMan
//
//  Created by 小河 on 17/3/21.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMQRCodePayTypeViewController.h"
#import <CoreImage/CoreImage.h>
#import <Masonry.h>
#import "XHSocketManager.h"
#import <SIOSocket/SIOSocket.h>
//#import "DPPaySucModel.h"
#import "FMArrivePaySuccessVC.h"
#import "FMArrivePaySuccessModel.h"
@interface FMQRCodePayTypeViewController ()
{
    UIImageView *_imgVew;
    UIView *_view1;
    NSInteger _timeNum;
}
@property(nonatomic,strong)NSThread *thread;
@property(nonatomic,strong)NSOperationQueue *queue;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)FMArrivePaySuccessModel *successModel;

@end

@implementation FMQRCodePayTypeViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_payType == SMViewControllerWeChatPay) {
        self.title = @"微信收款";
    }
    else
    {
        self.title = @"支付宝收款";
    }
    
    self.view.backgroundColor = kFMLGraryColor;
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-176)/2, 54, 176, 175)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    _view1=view1;
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 156, 155)];
    //[imgView setImage:[UIImage imageNamed:@"ewm"]];
    [view1 addSubview:imgView];
    _imgVew=imgView;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame)+20, ScreenWidth, 44)];
    label.text=[NSString stringWithFormat:@"订单号：%@",self.orderId];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16.0f];
    label.textColor=kFMBlueColor;
    [self.view addSubview:label];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+10, ScreenWidth, 44)];
    moneyLabel.textAlignment=NSTextAlignmentCenter;
    moneyLabel.font=[UIFont systemFontOfSize:16.0f];
    moneyLabel.text = [NSString stringWithFormat:@"订单金额：%.2f",[self.moneyNum doubleValue]];
    moneyLabel.textColor=kFMBlueColor;
    [self.view addSubview:moneyLabel];
   
    
    [self productORCodeWithUrl:self.codeUrl];
    
}

#pragma mark - 生成二维码
-(void)productORCodeWithUrl:(NSString*)url
{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3.二维码信息
    //NSString *str = @"hvklsfldvl/jg.dsmc"; // 展示一串文字
    //    NSString *str = @"http://www.baidu.com"; // 直接打开网页
    
    // 4.将字符串转成二进制数据
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 5.通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 6.获取滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 7.将CIImage转成UIImage
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    // 8.展示二维码
    _imgVew.image = image;
 
#pragma mark - 轮询请求后台接口
    //请求长链接
    [self initTimer];
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//--------------------------RunLoop下的轮询--------------
- (void)initTimer
{

//－－－－－－－－－－－－－－－－NSOperationQueue－－－－－－－－－－－－－－－－－－－
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 设置最大并发操作数
    //    queue.maxConcurrentOperationCount = 1; // 就变成了串行队列
    queue.maxConcurrentOperationCount = 2;
    // 添加操作
    [queue addOperationWithBlock:^{
        NSLog(@"当前线程----%@",[NSThread currentThread]);
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(runa) userInfo:nil repeats:YES];
        _timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];

    }];
    
    _queue = queue;
    
    
}
//定时器走的方法
-(void)runa
{
    _timeNum++;
    NSLog(@"当前----%@",[NSThread currentThread]);

    [AppUtils showWithStatus:nil];
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kCHECKPAYORDERSTATUE];
    NSDictionary *dic = @{
                          @"id":[_payId stringValue]
                              };
    [request NetRequestPOSTWithRequestURL:url WithParameter:dic WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        NSError *error = nil;
        FMArrivePaySuccessModel *successModel= [[FMArrivePaySuccessModel alloc]initWithDictionary:returnValue[@"data"] error:&error];
        self.successModel = successModel;
        //付款成功
        if ([_successModel.hasPay integerValue]==1) {
            FMArrivePaySuccessVC *vc = [[FMArrivePaySuccessVC alloc] init];
            vc.successModel = successModel;
            vc.orderID = self.orderId;
            if (_payType == SMViewControllerWeChatPay) {
                vc.payType = SMViewControllerSuccessWeChatPay;
                
            }
            else
            {
                vc.payType = SMViewControllerSuccessWeAlipyPay;
                
            }
            
            REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            [tabbarVc.childViewControllers[0] pushViewController:vc animated:YES];
        }
//        else

    
    } WithErrorCodeBlock:^(id errorCode) {
    
        [AppUtils dismissHUD];
        
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
    } WithFailureBlock:^{
     
        [AppUtils dismissHUD];
        
    }];

}
//--------------------------socket----------------------
//-(void)initDataWithSocket
//{
//    [XHSocketManager sharedInstance].socketHost = @"192.168.1.251";// host设定
//    [XHSocketManager sharedInstance].socketPort = 50000;// port设定    // 在连接前先进行手动断开
//    [[XHSocketManager sharedInstance] cutOffSocket];    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
//    [XHSocketManager sharedInstance].xhSocketManageDelegate = self;
////    [XHSingleton sharedInstance].socket.userData = SocketOfflineByServer;
//    
//    [[XHSocketManager sharedInstance] socketConnectHost];
//    
//}
//
//-(void)xhSocketManagerDidReadData:(NSData *)data withTag:(long)tag{
//    if (1) {
//        
//        //刷新UI
//        REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        [tabbarVc.childViewControllers[0] popViewControllerAnimated:YES];
//    }
//    else
//    {
//        
//    }
//    
//}
//
////--------------------------webSocket-------------------
////获取支付结果
//- (void)initDataWithWebSocket {
//    
//    NSString *token = [UserDefaultsUtils valueWithKey:kToken];
//    NSString *socketUrl = [NSString stringWithFormat:@"%@?Authorization=%@",SERVER_ADDRESS,token];
//    [SIOSocket socketWithHost:socketUrl response:^(SIOSocket *socket) {
//        
//        socket.onReconnect = ^(NSInteger i) {
//            NSLog(@"重连");
//        };
//        socket.onConnect = ^(NSInteger i) {
//            NSLog(@"链接成功");
//        };
//        socket.onReconnectionError = ^(NSDictionary *errorInfo) {
//            NSLog(@"%@",errorInfo);
//        };
//        socket.onDisconnect = ^(void){
//            NSLog(@"done");
//        };
//        socket.onError = ^(NSDictionary *error) {
//            NSLog(@"%@",error);
//        };
//        
//        
//        //接收服务端消息
//        [socket on:@"wechatPayReceived" callback:^(SIOParameterArray *args) {
//            
//            NSDictionary *result = args.firstObject;
//            NSError *error = nil;
//            DPPaySucModel *resultModel = [[DPPaySucModel alloc]initWithDictionary:result error:&error];
//            if (resultModel.status == 1) {
////                if([[NSString stringWithFormat:@"%@",self.dict[@"id"]] isEqualToString:resultModel.orderID] && self.orderPrice.doubleValue == resultModel.sum.doubleValue) {
////                    
////                    //支付成功
////                    DPPaySucessController *paySuccess = [[DPPaySucessController alloc]init];
////                    paySuccess.payModel = resultModel;
////                    [self.navigationController pushViewController:paySuccess animated:YES];
////                    
////                }
//                //支付成功 关闭连接
//                [socket close];
//            }else {
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付失败" message:resultModel.message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:cancleAction];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//            
//        }];
//        
//        //给服务端发消息
//        //        [socket emit:@"test" args:@[@"iOS"]];
//        
//        
//    }];
//    
//    
//}
//
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
