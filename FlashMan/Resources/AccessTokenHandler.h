//
//  AccessTokenHandler.h
//  diandaStore
//
//  Created by taitanxiami on 16/7/14.
//  Copyright © 2016年 taitanxiami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessTokenHandler : NSObject

+ (void)refreshTokenWithTimes:(NSInteger)times  block:(BaseResultBlock)block;
+ (void)clearToken;
@end
