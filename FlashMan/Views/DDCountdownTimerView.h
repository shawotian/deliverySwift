//
//  DDCountdownTimerView.h
//  diandaStore
//
//  Created by xiaohe on 16/1/28.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface DDCountdownTimerView : UIView
@property(nonatomic,strong)NSString *hour;
@property(nonatomic,strong)NSString *minite;
@property(nonatomic,strong)NSString *second;
@property(nonatomic,strong)UILabel *hourLabel;
@property(nonatomic,strong)UILabel *miniteLabel;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *lblTimerExample3;
//距离结束时间还是距离开始时间
@property(nonatomic,strong)NSString *titleStr;
@end
