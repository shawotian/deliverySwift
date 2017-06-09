//
//  XHView.m
//  店达商城
//
//  Created by xiaohe on 15/9/23.
//  Copyright (c) 2015年 diandainfo. All rights reserved.
//
//是否有网的键
#define LFIsNetWorking @"isNetWorking"

#import "XHView.h"
#define LFUserDefaults [NSUserDefaults standardUserDefaults]
@implementation XHView
//+ (void)showHudToView:(UIView *)view text:(NSString *)text
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = text;
//    
//}
+ (void)showTipHud:(NSString *)string superView:(UIView *)superView
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:superView];
    [superView addSubview:HUD];
    
    HUD.labelText = string;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        
        [HUD removeFromSuperview];
    }];
}

+ (void)hideHudFromView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
    //LeftCapWidth:wh 左右wh像素的宽度不会被拉伸
    //topCapHeight:wh 上下wh像素的高度不会被拉伸
    return [image stretchableImageWithLeftCapWidth:width topCapHeight:height];     
}
// 存值
+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [LFUserDefaults setObject:obj forKey:key];
    [LFUserDefaults synchronize];
}
+ (void)setBool:(BOOL)b forKey:(NSString *)key
{
    [LFUserDefaults setBool:b forKey:key];
    [LFUserDefaults synchronize];
}

// 取值
+ (id)objectForKey:(NSString *)key
{
    return [LFUserDefaults objectForKey:key];
}
+ (BOOL)boolForKey:(NSString *)key
{
    return [LFUserDefaults boolForKey:key];
}
+(NSInteger)sumDayOnYear:(NSInteger)year
{
  
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        //闰年
        return 366;
    }
    else
    {
        return 365;
    }
}
+(NSInteger)dayStWithYear:(NSInteger)year andMonth:(NSInteger)month andday:(NSInteger)day
{
    NSInteger sum=0;
    //int i;
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        //闰年
        switch (month) {
            case 1:
                sum=day;
                break;
            case 2:
                sum=31+day;
                break;
            case 3:
                sum=31+29+day;
                break;
            case 4:
                sum=31*2+29+day;
                break;
            case 5:
                sum=31*2+29+30+day;
                break;
            case 6:
                sum=31*3+30+29+day;
                break;
            case 7:
                sum=31*3+30*2+29+day;
                break;
            case 8:
                sum=31*4+30*2+29+day;
                break;
            case 9:
                sum=31*5+30*2+29+day;
                break;
            case 10:
                sum=31*5+30*3+29+day;
                break;
            case 11:
                sum=31*6+30*3+29+day;
                break;
            case 12:
                sum=31*6+30*4+29+day;
                break;
            default:
                break;
        }
        return sum;
    }
    else
    {
        //平年
        switch (month) {
            case 1:
                sum=day;
                break;
            case 2:
                sum=31+day;
                break;
            case 3:
                sum=31+28+day;
                break;
            case 4:
                sum=31*2+28+day;
                break;
            case 5:
                sum=31*2+28+30+day;
                break;
            case 6:
                sum=31*3+30+28+day;
                break;
            case 7:
                sum=31*3+30*2+28+day;
                break;
            case 8:
                sum=31*4+30*2+28+day;
                break;
            case 9:
                sum=31*5+30*2+28+day;
                break;
            case 10:
                sum=31*5+30*3+28+day;
                break;
            case 11:
                sum=31*6+30*3+28+day;
                break;
            case 12:
                sum=31*6+30*4+28+day;
                break;
            default:
                break;
        }
        return sum;
    }
}
//计算两个日期天数的差值
+(NSInteger)dayStWithYear:(NSInteger)year andMonth:(NSInteger)month andday:(NSInteger)day WithYear:(NSInteger)endYear andMonth:(NSInteger)endMonth andday:(NSInteger)endDay
{
    if (endYear==year) {
        //同一年
        if(endMonth==month)
        {
            NSInteger dayNum=endDay-day;
            return dayNum;
        }
        else
        {
            
            //当前时间为当年的第几天
            NSInteger nowDay=[self dayStWithYear:year andMonth:month andday:day];

            NSInteger endDayCha=[self dayStWithYear:endYear andMonth:endMonth andday:endDay];

            NSInteger dayNum=endDayCha-nowDay;
            return dayNum;
        }
    }
    else
    {
        //跨年
        if ((year%4==0&&year%100!=0)||(year%400==0)) {
            //闰年
            //当前时间为当年的第几天
            NSInteger nowDay=[self dayStWithYear:year andMonth:month andday:day];
            NSInteger endDayCha=[self dayStWithYear:endYear andMonth:endMonth andday:endDay];
            NSInteger dayNum=366-nowDay+endDayCha;
            return dayNum;
        }
        else
        {
            //平年
            //当前时间为当年的第几天
            NSInteger nowDay=[self dayStWithYear:year andMonth:month andday:day];
            NSInteger endDayCha=[self dayStWithYear:endYear andMonth:endMonth andday:endDay];
            NSInteger dayNum=365-nowDay+endDayCha;
            return dayNum;
        }
        
    }

}

#pragma mark 检测网络
- (void)checkNetWorking {
    // 网络检测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 开启网络检测
    [manager startMonitoring];
    
    // 设置网络检测返回的block
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: // 没有网络
                // 存储是否有网
                [XHView setBool:NO forKey:LFIsNetWorking];
                //[self createUI];
                break;
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                [XHView setBool:YES forKey:LFIsNetWorking];
                //[self createUI];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // Wifi网络
                [XHView setBool:YES forKey:LFIsNetWorking];
                //[self createUI];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 3/4G网络
                [XHView setBool:YES forKey:LFIsNetWorking];
                //[self createUI];
                break;
                
            default:
                break;
        }
    }];
}
//创建一个textfeild
+ (UITextField * )createTextFeildWithFrame:(CGRect)frame placeholder:(NSString*)placeholder placeholderColor:(UIColor*)placeholderColor placeholderFont:(UIFont *)placeholderFont superView:(UIView *)superView target:(id)target
{
    //填写优惠劵的textfeild
    UITextField *tf =[[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth/16,20, ScreenWidth/8*7, 40)];
    tf.delegate=target;
    tf.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    tf.placeholder=placeholder;
    [tf setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [tf setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
    
    tf.borderStyle=UITextBorderStyleLine;
    
    //textfeild的左边的空白view
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 10, 30)];
    leftView.alpha=0;
    tf.leftView=leftView;
    tf.layer.borderColor = kFMLLineGraryColor.CGColor;
    tf.layer.borderWidth = 1.0f;
    tf.leftViewMode=UITextFieldViewModeAlways;
    [superView addSubview:tf];
    return tf;
}
//创建一个按钮
+ (UIButton *)createBtnWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor setImgName:(NSString *)imgName target:(id)target action:(SEL)action superView:(UIView *)superView
{
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:frame];
    shareBtn.backgroundColor=backgroundColor;
    [shareBtn setTitle:text forState:UIControlStateNormal];
    [shareBtn setTitleColor:textColor forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgName]] forState:UIControlStateNormal];
    [shareBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:shareBtn];
    return shareBtn;
}
//创建一个label
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)textColor font:(UIFont *)font superView:(UIView *)superView
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.text = text;
    titleLabel.textColor = textColor;
    titleLabel.font = font;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [superView addSubview:titleLabel];
    return titleLabel;
}
// 创建imageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame setImage:(UIImage *)image superView:(UIView *)superView
{
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:frame];
    [imgView setImage:image];
    [superView addSubview:imgView];
    return imgView;
}


+(MJRefreshGifHeader*)customTopHeaderWithHearder:(MJRefreshGifHeader*)header
{
    // 设置普通状态的动画图片
    NSMutableArray *idleImages=[NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%ld", (long)i]];
        [idleImages addObject:image];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *pullingImages=[NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [pullingImages addObject:image];
    }
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header setImages:pullingImages forState:MJRefreshStateRefreshing];
    [header setTitle:nil forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;

    return header;
}
//跑马灯效果
+(void)marqueeWithContentLabel:(UILabel*)contentLabel withcontentWords:(NSString *)contentWords withFont:(UIFont*)font withLabelFrame:(CGRect)labelFrame target:(id)target withNum:(NSInteger)number
{
    __block NSInteger num=number;
    
    CGFloat width= [Helper widthOfString:contentLabel.text font:font height:labelFrame.size.height];
    CGFloat speed=50.0;
    CGFloat distance=width+labelFrame.size.width;//(109是父视图view的宽度)
    if (num>0) {
        contentLabel.frame=CGRectMake(labelFrame.size.width, 0, width, labelFrame.size.height);
    }
    else
    {
        contentLabel.frame=CGRectMake(20, 0, width, labelFrame.size.height);
    }
    
    [UIView animateWithDuration:distance/speed animations:^{
        CGRect frame =CGRectMake(-width, 0, width, labelFrame.size.height);
        contentLabel.frame=frame;
        num++;
    } completion:^(BOOL finished) {
        [XHView marqueeWithContentLabel:contentLabel withcontentWords:contentWords withFont:font withLabelFrame:labelFrame target:target withNum:num];
    }];
    
}
+ (UIImage *)resizeImage:(UIImage *)image wh:(CGFloat)wh
{
    //LeftCapWidth:wh 左右wh像素的宽度不会被拉伸
    //topCapHeight:wh 上下wh像素的高度不会被拉伸
    return [image stretchableImageWithLeftCapWidth:wh topCapHeight:wh];
}
// 创建背景view
+ (UIView *)createBackgroundViewWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor superView:(UIView *)superView
{
    UIView *backGroundView=[[UIView alloc]initWithFrame:frame];
    backGroundView.backgroundColor=backgroundColor;
    [superView addSubview:backGroundView];
    return backGroundView;
}


@end
