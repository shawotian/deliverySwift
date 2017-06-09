//
//  ScanViewController.m
//  faceShopping
//
//  Created by xiaohe on 16/6/14.
//  Copyright © 2016年 ctc. All rights reserved.
//

#import "DDScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FMWriteCodeViewController.h"
@interface DDScanViewController ()<UITabBarDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * previewLayer;

//
@property (strong, nonatomic) UIImageView *scanLineImageView;
@property (strong, nonatomic) UIImageView *scanBorderImageView;

@property (strong, nonatomic) NSLayoutConstraint *containerHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *scanLineTopConstraint;

@property(nonatomic,strong)UIView *customContainerView;
@property(nonatomic,strong)UILabel *customLabel;


/*** 专门用于保存描边的图层 ***/
@property (nonatomic,strong) CALayer *containerLayer;
@end

@implementation DDScanViewController
// 界面显示,开始动画
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self startAnimation];
    // 清除之前的描边
    [self clearLayers];
    self.customLabel.text=@"将条码/二维码放入框内，将自动扫码，扫码成功即取货";
    [self.session startRunning];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"扫一扫";
    self.view.backgroundColor=[UIColor whiteColor];
//    UIButton *scanBtn=[XHView createBtnWithFrame:CGRectMake(0, 0, 80, 27) text:@"相册" textColor:nil backgroundColor:[UIColor clearColor] setImgName:nil target:self action:@selector(scanBtnClicked) superView:nil];
//    UIBarButtonItem *itemBtn=[[UIBarButtonItem alloc]initWithCustomView:scanBtn];
//    self.navigationItem.rightBarButtonItem=itemBtn;
    
    [self addSubViews];
    
    // Do any additional setup after loading the view.
}
#pragma mark 搭建页面
-(void)addSubViews
{
    CGFloat borderW=240;
    self.customContainerView=[XHView createBackgroundViewWithFrame:CGRectMake((ScreenWidth-borderW)/2, 100, borderW, borderW) backgroundColor:[UIColor clearColor] superView:self.view];
    self.customContainerView.clipsToBounds=YES;
    self.scanBorderImageView=[XHView createImageViewWithFrame:CGRectMake(0, 0, borderW, borderW) setImage:[UIImage imageNamed:@"erweima01"] superView:self.customContainerView];
    self.customLabel=[XHView createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(_customContainerView.frame)+10,ScreenWidth, 40) text:@"将条码/二维码放入框内，将自动扫码，扫码成功即取货" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0f] superView:self.view];
    self.customLabel.numberOfLines = 0;
    
    UIButton *btn = [XHView createBtnWithFrame:CGRectMake((ScreenWidth-150)/2, CGRectGetMaxY(self.customLabel.frame)+10, 150, 40) text:@"手动输入条形码" textColor:[UIColor whiteColor] backgroundColor:kFMBlueColor setImgName:nil target:self action:@selector(codeBtnClicked) superView:self.view];
    btn.layer.cornerRadius = 3.0f;
    btn.clipsToBounds = YES;
    
    
    self.customLabel.textAlignment=NSTextAlignmentCenter;
    self.scanLineImageView=[XHView createImageViewWithFrame:CGRectMake(2, 2, borderW-4, borderW-4) setImage:[UIImage imageNamed:@"erweima02"] superView:self.customContainerView];
    
    // 开始扫描二维码
    [self startScan];
}
#pragma mark  属性的懒加载
- (AVCaptureDevice *)device
{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}
// 设置输出对象解析数据时感兴趣的范围
// 默认值是 CGRect(x: 0, y: 0, width: 1, height: 1)
// 通过对这个值的观察, 我们发现传入的是比例
// 注意: 参照是以横屏的左上角作为, 而不是以竖屏
//        out.rectOfInterest = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        
        // 1.获取屏幕的frame
        CGRect viewRect = self.view.frame;
        // 2.获取扫描容器的frame
        CGRect containerRect = self.customContainerView.frame;
        
        CGFloat x = containerRect.origin.y / viewRect.size.height;
        CGFloat y = containerRect.origin.x / viewRect.size.width;
        CGFloat width = containerRect.size.height / viewRect.size.height;
        CGFloat height = containerRect.size.width / viewRect.size.width;
        
        // CGRect outRect = CGRectMake(x, y, width, height);
        // [_output rectForMetadataOutputRectOfInterest:outRect];
        _output.rectOfInterest = CGRectMake(x, y, width, height);
    }
    return _output;
}

- (CALayer *)containerLayer
{
    if (_containerLayer == nil) {
        _containerLayer = [[CALayer alloc] init];
    }
    return _containerLayer;
}
#pragma mark 开始扫描
- (void)startScan
{
    // 1.判断输入能否添加到会话中
    if (![self.session canAddInput:self.input]) return;
    [self.session addInput:self.input];
    
    // 2.判断输出能够添加到会话中
    if (![self.session canAddOutput:self.output]) return;
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
//    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    //设置识别二维码或者条码，这里可以识别二维码和条形码(只有AVMetadataObjectTypeQRCode是二维码，其他常量都是条码)
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code];
    // 5.设置监听监听输出解析到的数据
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6.添加预览图层
    self.previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 7.添加容器图层
    [self.view.layer addSublayer:self.containerLayer];
    self.containerLayer.frame = self.view.bounds;
    
    // 8.开始扫描
    [self.session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
//扫描成功之后调用的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // id 类型不能点语法,所以要先去取出数组中对象
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
    
    if (object == nil) return;
    // 只要扫描到结果就会调用
    self.customLabel.text = object.stringValue;
    
    // 清除之前的描边
    [self clearLayers];

    // 对扫描到的二维码进行描边
    AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];
    
    // 绘制描边
    [self drawLine:obj];
    
    
//进入领货单页面
    [self.session stopRunning];
    //1.待取货插页:扫描前置仓人员出示的订单二维码后,自动判断扫描的单号是否是待取货中的单号,
    //如果不是,则提示此单号不属于取货中的单号
    //如果是,则提示:取货成功,并将此单的配送状态由待取货改成:配送中
    [self postGetGoodsDataWithOrderId:object.stringValue];
    
}
#pragma mark - 取货
-(void)postGetGoodsDataWithOrderId:(NSString *)orderId {
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kGETGOODS];
    
    NSDictionary *dict = @{
                           @"QRCode":orderId
                           };
    [request NetRequestPOSTWithRequestURL:url WithParameter:dict WithReturnValeuBlock:^(id returnValue) {
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"取货成功";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            
            [HUD removeFromSuperview];
            REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabbarVc.childViewControllers[0] popViewControllerAnimated:YES];
        }];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = errorCode[@"message"];
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            
            [HUD removeFromSuperview];
            REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabbarVc.childViewControllers[0] popViewControllerAnimated:YES];
        }];
        
        
    } WithFailureBlock:^{
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"取货失败";
        HUD.mode = MBProgressHUDModeText;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1.0);
        } completionBlock:^{
            
            [HUD removeFromSuperview];
            REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            [tabbarVc.childViewControllers[0] popViewControllerAnimated:YES];
        }];
        
    }];
    

}
#pragma mark 利用贝塞尔曲线绘制描边
- (void)drawLine:(AVMetadataMachineReadableCodeObject *)objc
{
    NSArray *array = objc.corners;
    
    // 1.创建形状图层, 用于保存绘制的矩形
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    // 设置线宽
    layer.lineWidth = 1;
    // 设置描边颜色
    layer.strokeColor = kFMLLineGraryColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.创建UIBezierPath, 绘制矩形
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    int index = 0;
    
    CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[index++]);
    // 把点转换为不可变字典
    // 把字典转换为点，存在point里，成功返回true 其他false
    CGPointMakeWithDictionaryRepresentation(dict, &point);
    
    // 设置起点
    [path moveToPoint:point];
    
    // 2.2连接其它线段
    for (int i = 1; i<array.count; i++) {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)array[i], &point);
        [path addLineToPoint:point];
    }
    // 2.3关闭路径
    [path closePath];
    
    layer.path = path.CGPath;
    // 3.将用于保存矩形的图层添加到界面上
    [self.containerLayer addSublayer:layer];
}
#pragma mark 清除描边
- (void)clearLayers
{
    if (self.containerLayer.sublayers)
    {
        for (CALayer *subLayer in self.containerLayer.sublayers)
        {
            [subLayer removeFromSuperlayer];
        }
    }
}

#pragma mark 实现相册二维码识别
//1.打开系统相册
-(void)scanBtnClicked{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 4.设置代理
    ipc.delegate = self;
    
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}
//2.实现代理方法(注意需要遵守两个代理协议)
#pragma mark -------- UIImagePickerControllerDelegate---------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    // 2.从选中的图片中读取二维码数据
    // 2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    // 2.3取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        // NSLog(@"%@",result.messageString);
        NSString *urlStr = result.messageString;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
    // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 开启冲击波动画
- (void)startAnimation
{
    CGFloat borderW=240;
    // 1.设置冲击波底部和容器视图顶部对齐
//    self.scanLineTopConstraint.constant = - self.containerHeightConstraint.constant;
    self.scanLineImageView.frame=CGRectMake(2, -borderW+40, borderW-4, borderW-4);
    // 刷新UI
    [self.view layoutIfNeeded];
    
    // 2.执行扫描动画
    [UIView animateWithDuration:1.0 animations:^{
        // 无线重复动画
        [UIView setAnimationRepeatCount:MAXFLOAT];
//        self.scanLineTopConstraint.constant = self.containerHeightConstraint.constant;
        self.scanLineImageView.frame=CGRectMake(2, 40, borderW-4, borderW-4);
        // 刷新UI
        [self.view layoutIfNeeded];
    } completion:nil];
}

//3.在界面消失的时候关闭session
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    
    
}
-(void)codeBtnClicked
{
    FMWriteCodeViewController *vc = [[FMWriteCodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
