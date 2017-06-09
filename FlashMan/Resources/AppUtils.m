//
//  AppUtils.m
//  zlydoc+iphone
//
//  Created by Ryan on 14+5+23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "AppUtils.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <CommonCrypto/CommonDigest.h>
#import <DateTools.h>
#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation AppUtils

/********************* System Utils **********************/
+ (void)showAlertMessage:(NSString *)msg title:(NSString *)title
{
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
//        
//        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            
//        }];
//        [alertView addAction:cancelAction];
//        
//        
//    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];

//    }
}

+ (void)closeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+ (NSString *)md5FromString:(NSString *)str
{    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];

}
//获取当前时间的时间戳
+ (NSString *)getDateString {
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}
+ (NSString *)stringByReversed:(NSString *)string;
{
    NSUInteger i = 0;
    NSUInteger j = string.length - 1;
    NSString *temp;
    NSString *newString = string;
    while (i < j) {
        temp = [newString substringWithRange:NSMakeRange(i, 1)];
        newString = [newString stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[string substringWithRange:NSMakeRange(j, 1)]];
        newString = [newString stringByReplacingCharactersInRange:NSMakeRange(j, 1) withString:temp];
        
        i ++;
        j --;
    }
    
    return newString;
}
/******* UITableView & UINavigationController Utils *******/
+ (UILabel *)tableViewsHeaderLabelWithMessage:(NSString *)message
{
    UILabel *lb_headTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
    lb_headTitle.font = [UIFont boldSystemFontOfSize:15.0];
    lb_headTitle.textColor = [UIColor darkGrayColor];
    lb_headTitle.textAlignment = NSTextAlignmentCenter;
    lb_headTitle.text = message;
    return lb_headTitle;
}

+ (UIView *)tableViewsFooterView
{
    UIView *coverView = [UIView new];
    coverView.backgroundColor = [UIColor clearColor];
    return coverView;
}

+ (UIBarButtonItem *)navigationBackButtonWithNoTitle
{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

/********************* SVProgressHUD **********************/
+ (void)showSuccessMessage:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showErrorMessage:(NSString *)message
{
    [SVProgressHUD showErrorWithStatus:message];
}

+ (void)showProgressMessage:(NSString *) message
{
    [SVProgressHUD showWithStatus:message];
}

+ (void)showWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status];
}

+ (void)showWithStatus:(NSString *)status withMaskType:(SVProgressHUDMaskType)type {
    [SVProgressHUD setDefaultMaskType:type];
    [SVProgressHUD showWithStatus:status];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

+(NSDate *)getDate {
    
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    return  [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
}
/********************** NSDate Utils ***********************/
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: [dateFormatter dateFromString:dateString]];
    NSDate *localeDate = [[dateFormatter dateFromString:dateString] dateByAddingTimeInterval: interval];
    return localeDate;
}

/********************* Category Utils **********************/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/********************* Verification Utils **********************/
+ (BOOL)checkPhoneNumber:(NSString *)mobileNum{
    
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (NSString *)getAPPVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString *)getImageUrlString:(NSString *)url imageType:(NSString *)type {
    
    NSString *newImageUrlsting = nil;
    
    NSMutableArray *compents = (NSMutableArray *)[url componentsSeparatedByString:@"."];
    
    NSString *compentString = compents[compents.count - 2];
    NSString *lastUrlString = [NSString stringWithFormat:@"%@_%@",compentString,type];

    [compents replaceObjectAtIndex:compents.count - 2 withObject:lastUrlString];
    for (NSInteger i = 0; i<compents.count; i++) {
        
        if (i == 0) {
            newImageUrlsting = compents[i];
        }else {
            
            newImageUrlsting  = [NSString stringWithFormat:@"%@.%@",newImageUrlsting,compents[i]];
        }
    }
    
    
    return newImageUrlsting;
}

+ (NSString *)stroreNameLimitWitName:(NSString *)name {
    
    NSString *newName = name;
    if (newName.length > 2) {
       newName =  [newName substringWithRange:NSMakeRange(0, 2)];
    }
    newName = [NSString stringWithFormat:@"%@**",newName];
    return newName;
}

+ (NSString *)showNewsCurrentDate:(NSString *)creatAt {
    
    NSDate *date = [AppUtils dateFromString:creatAt formatter:@"yyyy-MM-dd HH:mm:ss"];
    NSInteger ago = [date daysAgo];
    
    NSString *dateString = nil;
    NSArray *components = [creatAt componentsSeparatedByString:@" "];
    if (ago == 0) {
        dateString = components.lastObject;
    }else if (ago == 1) {
        dateString = @"昨天";
    }else if(ago == 2) {
        dateString = @"前天";
    }else {
        
        dateString = components.firstObject;
    }
    return dateString;
}


+ (NSString *)currentTime {    
    
      return  [AppUtils stringFromDate:[NSDate date] formatter:@"MM月dd日 HH:mm:ss"];
}

+ (NSString *)currentWeek {
    
    NSInteger week;
    NSString *weekStr=nil;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday ;
    
    comps = [calendar components:unitFlags fromDate:now];
    week = [comps weekday];
    
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    else {
        NSLog(@"error!");
    }
    
    return weekStr;
}
+(void)saveValue:(id)paramas forPlistKey:(NSString *)file {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:file];
    [paramas writeToFile:fileName atomically:YES];
}

+ (NSDictionary *)fetchPlistValueForKey:(NSString *)file {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:file];
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return result;
}
@end
