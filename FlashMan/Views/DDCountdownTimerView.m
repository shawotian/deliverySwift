//
//  DDCountdownTimerView.m
//  diandaStore
//
//  Created by xiaohe on 16/1/28.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import "DDCountdownTimerView.h"

@implementation DDCountdownTimerView
- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews
{
    UILabel *titleLabel=[XHView createLabelWithFrame:CGRectMake(0, 0, 73, 17) text:self.titleStr textColor:kFMBlackColor font:[UIFont systemFontOfSize:12.0f] superView:self];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel=titleLabel;
    //时
    UILabel *hourLabel=[XHView createLabelWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame), 19, 19) text:@"00" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:12.0f] superView:self];
    hourLabel.textAlignment=NSTextAlignmentCenter;
//    hourLabel.backgroundColor=kFMBlackColor;
    hourLabel.clipsToBounds=YES;
    hourLabel.layer.cornerRadius=3.0f;
    _hourLabel=hourLabel;
    UILabel *dianLabel1=[XHView createLabelWithFrame:CGRectMake(CGRectGetMaxX(hourLabel.frame), CGRectGetMaxY(titleLabel.frame), 8, 19) text:@":" textColor:kFMBlackColor font:[UIFont systemFontOfSize:12.0f] superView:self];
    dianLabel1.textAlignment=NSTextAlignmentCenter;
    //分
    UILabel *miniteLabel=[XHView createLabelWithFrame:CGRectMake(CGRectGetMaxX(dianLabel1.frame), CGRectGetMaxY(titleLabel.frame), 19, 19) text:@"00" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:12.0f] superView:self];
    miniteLabel.textAlignment=NSTextAlignmentCenter;
//    miniteLabel.backgroundColor=kFMBlackColor;
    miniteLabel.clipsToBounds=YES;
    miniteLabel.layer.cornerRadius=3.0f;
    _miniteLabel=miniteLabel;
    UILabel *dianLabel2=[XHView createLabelWithFrame:CGRectMake(CGRectGetMaxX(miniteLabel.frame), CGRectGetMaxY(titleLabel.frame), 8, 19) text:@":" textColor:kFMBlackColor font:[UIFont systemFontOfSize:12.0f] superView:self];
    dianLabel2.textAlignment=NSTextAlignmentCenter;
    //秒
    UILabel *secondLabel=[XHView createLabelWithFrame:CGRectMake(CGRectGetMaxX(dianLabel2.frame), CGRectGetMaxY(titleLabel.frame), 19, 19) text:@"" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:12.0f] superView:self];
    secondLabel.textAlignment=NSTextAlignmentCenter;
//    secondLabel.backgroundColor=kFMBlackColor;
    secondLabel.clipsToBounds=YES;
    secondLabel.layer.cornerRadius=3.0f;
    _secondLabel=secondLabel;
}
-(void)setHour:(NSString *)hour
{
    _hourLabel.text=[NSString stringWithFormat:@"%@",hour];
}
-(void)setMinite:(NSString *)minite
{
    _miniteLabel.text=[NSString stringWithFormat:@"%@",minite];
}
-(void)setSecond:(NSString *)second
{
    _secondLabel.text=[NSString stringWithFormat:@"%@",second];
}
-(void)setLblTimerExample3:(UILabel *)lblTimerExample3
{
    NSString *timeStr=[NSString stringWithFormat:@"%@",lblTimerExample3.text];
    NSArray *timeArray=[timeStr componentsSeparatedByString:@":"];
    _hourLabel.text=[NSString stringWithFormat:@"%@",timeArray[0]];
    _miniteLabel.text=[NSString stringWithFormat:@"%@",timeArray[1]];
    _secondLabel.text=[NSString stringWithFormat:@"%@",timeArray[2]];
}
-(void)setTitleStr:(NSString *)titleStr
{
    _titleLabel.text=titleStr;
}
@end
