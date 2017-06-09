//
//  DDQRCodeViewController.m
//  diandaStore
//
//  Created by xiaohe on 15/10/29.
//  Copyright © 2015年 taitanxiami. All rights reserved.
//

#import "DDQRCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import <Masonry.h>
//#import <RDVTabBarController.h>
@interface DDQRCodeViewController ()
{
    UIImageView *_imgVew;
    UIView *_view1;
}
@end

@implementation DDQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺二维码";
    self.view.backgroundColor = kFMLGraryColor;
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-176)/2, 54, 176, 175)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    _view1=view1;
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 156, 155)];
    //[imgView setImage:[UIImage imageNamed:@"ewm"]];
    [view1 addSubview:imgView];
    _imgVew=imgView;
    
//      __weak typeof(self)weakself = self;
//    
//    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusbarH+NavigationBarH+20);
//        make.centerX.equalTo(weakself.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(176, 175));
//    }];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_view1.frame)+20, ScreenWidth, 44)];
    label.text=[NSString stringWithFormat:@"订单号：%@",self.rejectCode];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16.0f];
    label.textColor=kFMBlueColor;
    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(view1.mas_bottom).offset(20);
//        make.centerX.equalTo(weakself.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 44));
//    }];
//    
    [self productORCodeWithUrl:self.rejectCode];
    
    
}
//-(void)initData
//{
//    __weak typeof(self)weakself = self;
//    NetRequestClass *request=[[NetRequestClass alloc]init];
//    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kQRCODEURL];
//    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
//        NSString *url=returnValue[@"data"];
//        
//    } WithErrorCodeBlock:^(id errorCode) {
//        
//        [weakself showTipHud:errorCode[kMESSAGE]];
//
//    } WithFailureBlock:^{
//        
//    }];
//
//}
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
//-(void)btnClicked
//{
//    DDQRCodeScanViewController *vc=[[DDQRCodeScanViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
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
