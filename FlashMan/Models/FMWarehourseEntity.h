//
//  FMWarehourseEntity.h
//  FlashMan
//
//  Created by dianda on 2017/1/21.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FMWarehourseEntity : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*sum;
@property (strong, nonatomic) NSString <Optional>*warehouseAddress;

@end
