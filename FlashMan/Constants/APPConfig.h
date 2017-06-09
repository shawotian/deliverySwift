//
//  APPConfig.h
//  dogBuy
//
//  Created by taitanxiami on 2016/10/8.
//  Copyright © 2016年 diandactc. All rights reserved.
//

#ifndef APPConfig_h
#define APPConfig_h

//********屏幕宽度********
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight     [UIScreen mainScreen].bounds.size.height
// 状态栏(statusbar)高
#define StatusbarH [[UIApplication sharedApplication] statusBarFrame].size.height
//导航栏高度
#define NavigationBarH self.navigationController.navigationBar.frame.size.height
//tabbar高度
#define TabbarH self.tabBarController.tabBar.frame.size.height


//全局颜色设置
#define kFMBlueColor     [UIColor colorWithHexString:@"159ceb"]
#define kFMRedColor     [UIColor colorWithHexString:@"ff0000"]
#define kFMGreenColor     [UIColor colorWithHexString:@"79c213"]

#define kFMBlackColor     [UIColor colorWithHexString:@"282828"]
#define kFMWordGrayColor [UIColor colorWithHexString:@"a5a5a5"]
//灰
#define kFMDGraryColor     [UIColor colorWithHexString:@"b2b2b2"]
//浅灰
#define kFMLGraryColor     [UIColor colorWithHexString:@"e5e5e5"]
//白色
#define kFMWhiteColor [UIColor colorWithHexString:@"ffffff"]
#define kFMDLineGraryColor [UIColor colorWithHexString:@"e5e5e5"]
#define kFMLLineGraryColor [UIColor colorWithHexString:@"f0f0f0"]



#define k12SizeFont [UIFont systemFontOfSize:12]
#define k15SizeFont [UIFont systemFontOfSize:15]
#define k18SizeFont [UIFont systemFontOfSize:18]
#define k20SizeFont [UIFont systemFontOfSize:20]
#define k30SizeFont [UIFont systemFontOfSize:30]

//全局字体设置


#endif /* APPConfig_h */
