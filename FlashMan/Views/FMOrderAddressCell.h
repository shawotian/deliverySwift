//
//  FMOrderAddressCell.h
//  FlashMan
//
//  Created by dianda on 2017/1/9.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMOrderAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *pickAddress;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLable;
@property (weak, nonatomic) IBOutlet UILabel *storeAddress;
@property (weak, nonatomic) IBOutlet UILabel *pickDateLable;
@end
