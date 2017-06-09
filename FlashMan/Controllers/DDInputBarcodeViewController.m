//
//  DDInputBarcodeViewController.m
//  diandaStore
//
//  Created by xiaohe on 15/12/17.
//  Copyright © 2015年 taitanxiami. All rights reserved.
//

#import "DDInputBarcodeViewController.h"
@interface DDInputBarcodeViewController ()
@property(nonatomic,strong)UITextField *tf;
@end

@implementation DDInputBarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入条形码";
    self.view.backgroundColor=kFMLGraryColor;
    [self addSubViews];
}
-(void)addSubViews
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 230)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UITextField *tf=[XHView createTextFeildWithFrame:CGRectMake(ScreenWidth/16,30, ScreenWidth/8*7, 40) placeholder:@"请输入条形码" placeholderColor:[UIColor colorWithHexString:@"e7e3e4"] placeholderFont:[UIFont boldSystemFontOfSize:16] superView:view target:self];
    _tf=tf;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.borderStyle=UITextBorderStyleRoundedRect;
    tf.clipsToBounds=YES;
    tf.layer.cornerRadius=3.0f;
    UIButton *searchBtn = [XHView createBtnWithFrame:CGRectMake(ScreenWidth/16, CGRectGetMaxY(tf.frame)+20, ScreenWidth/8*7, 40) text:@"搜索" textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] setImgName:nil target:self action:@selector(searchBtnClicked) superView:view];
    searchBtn.clipsToBounds=YES;
    searchBtn.layer.cornerRadius=3.0;
    
    [XHView createBtnWithFrame:CGRectMake(ScreenWidth-ScreenWidth/16-100, CGRectGetMaxY(searchBtn.frame)+20, 100, 40) text:@"切换扫码" textColor:[UIColor redColor] backgroundColor:[UIColor whiteColor] setImgName:@"qhsmzl" target:self action:@selector(switchSaoClicked) superView:view];
} 
#pragma mark 响应事件
-(void)searchBtnClicked
{
//    DDScanResultViewController *scanResultVC=[[DDScanResultViewController alloc]init];
//    scanResultVC.controlViewType= ScanControlTypeSCan;
//    scanResultVC.keyword=_tf.text;
//    
//    if (_tf.text.length>0) {
//       [self.navigationController pushViewController:scanResultVC animated:YES];
//    }
//    else
//    {
//        [self showTipHud:@"请输入条形码"];
//    }
    
}
-(void)switchSaoClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
