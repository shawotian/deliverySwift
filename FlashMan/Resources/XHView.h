//
//  XHView.h
//  店达商城
//
//  Created by xiaohe on 15/9/23.
//  Copyright (c) 2015年 diandainfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHView : NSObject
// 显示缓冲视图
//+ (void)showHudToView:(UIView *)view text:(NSString *)text;
+ (void)showTipHud:(NSString *)string superView:(UIView *)superView;
// 隐藏缓冲视图
+ (void)hideHudFromView:(UIView *)view;
// 设置image上下左右wh像素不被拉伸
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;

// NSUserDefaults 存值
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (void)setBool:(BOOL)b forKey:(NSString *)key;

// NSUserDefaults 取值
+ (id)objectForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+(NSInteger)sumDayOnYear:(NSInteger)year;
+(NSInteger)dayStWithYear:(NSInteger)year andMonth:(NSInteger)month andday:(NSInteger)day;
//计算两个日期天数的差值
+(NSInteger)dayStWithYear:(NSInteger)year andMonth:(NSInteger)month andday:(NSInteger)day WithYear:(NSInteger)endYear andMonth:(NSInteger)endMonth andday:(NSInteger)endDay ;
- (void)checkNetWorking;
//创建一个textfeild
+ (UITextField * )createTextFeildWithFrame:(CGRect)frame placeholder:(NSString*)placeholder placeholderColor:(UIColor*)placeholderColor placeholderFont:(UIFont *)placeholderFont superView:(UIView *)superView target:(id)target;
// 创建标签
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)textColor font:(UIFont *)font superView:(UIView *)superView;
// 按钮
+ (UIButton *)createBtnWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor setImgName:(NSString *)imgName target:(id)target action:(SEL)action superView:(UIView *)superView;
// 创建imageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame setImage:(UIImage *)image superView:(UIView *)superView;
//封装一个头部刷新
+(MJRefreshGifHeader*)customTopHeaderWithHearder:(MJRefreshGifHeader*)header;
+(void)marqueeWithContentLabel:(UILabel*)contentLabel withcontentWords:(NSString *)contentWords withFont:(UIFont*)font withLabelFrame:(CGRect)labelFrame target:(id)target withNum:(NSInteger)number
;
+ (UIImage *)resizeImage:(UIImage *)image wh:(CGFloat)wh;
+ (UIView *)createBackgroundViewWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor superView:(UIView *)superView
;
@end
