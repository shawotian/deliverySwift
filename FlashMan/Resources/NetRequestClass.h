//
//  NetRequestClass.h
//
//  Created by taitanxiami on 15/1/6.
//  Copyright (c) 2015年 taitanxiami. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NetRequestClass : NSObject

#pragma 监测网络的可链接性

- (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma POST请求
- (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;

#pragma GET请求
- (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;

#pragma GET TOKEN
- (void)getTokenWithParamas:(NSDictionary *)paramas
                  withTimes:(NSInteger)times
                returnBlack:(ReturnValueBlock)returnValueBlock;
@end
