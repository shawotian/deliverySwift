//
//  SMOrderTitleCollectionViewCell.h
//  SaleMan
//
//  Created by 小河 on 16/10/17.
//  Copyright © 2016年 diandactc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOrderTitleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *blueView;


// 复用id
+ (NSString *)identifier;
@end
