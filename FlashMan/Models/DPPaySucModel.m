//
//  DPPaySucModel.m
//  DeliveryPerson
//
//  Created by dianda on 2016/11/22.
//  Copyright © 2016年 ctc. All rights reserved.
//

#import "DPPaySucModel.h"

@implementation DPPaySucModel


+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"orderID": @"id"                                                                  }];
}
@end
