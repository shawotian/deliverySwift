//
//  APPConstant.h
//  SaleMan
//
//  Created by dianda on 2016/10/12.
//  Copyright © 2016年 diandactc. All rights reserved.
//

#ifndef APPConstant_h
#define APPConstant_h

#ifdef DEBUG
# define DLog(format, ...) NSLog((@"[行号:%d]" format), __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);

//
//#if DEBUG
//#define kBAIDUMAPKEY  @"vDv3G2DYg5AxSDKYYuDagAZgVTlYMtDv"
//#else
//#define kBAIDUMAPKEY  @"yx4lFZxhezbXoGcU1s12Cc4f0HD1urAy"
//#endif
//

#endif /* APPConstant_h */
