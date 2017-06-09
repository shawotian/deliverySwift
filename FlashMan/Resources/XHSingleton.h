//
//  XHSingleton.h
//  FlashMan
//
//  Created by 小河 on 17/3/23.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//
enum {
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser// 用户主动cut
};
#import <Foundation/Foundation.h>


#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) 

//static dispatch_once_t onceToken = 0; 
@interface XHSingleton : NSObject+ (XHSingleton *)sharedInstance;

@property (nonatomic, strong) GCDAsyncSocket *socket; // socket
@property (nonatomic, copy ) NSString *socketHost; // socket的Host
@property (nonatomic, assign) UInt16 socketPort; // socket的port
@property (nonatomic, retain) NSTimer *connectTimer; // 计时器
-(void)socketConnectHost;// socket连接
-(void)cutOffSocket; // 断开socket连接

@end
