//
//  XHSingleton.m
//  FlashMan
//
//  Created by 小河 on 17/3/23.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "XHSingleton.h"
@interface XHSingleton()<GCDAsyncSocketDelegate>
@end
@implementation XHSingleton
+(XHSingleton *) sharedInstance
{
    static XHSingleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}
// socket连接
-(void)socketConnectHost{
    dispatch_queue_t que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:nil];
    NSError *error = nil;
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
}
#pragma mark - 连接成功回调
-(void)onSocket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"socket连接成功");
    // 每隔30s像服务器发送心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    // 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    [self.connectTimer fire];
}
// 心跳连接
-(void)longConnectToSocket{
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    NSString *longConnect = @"longConnect";
    NSData *dataStream = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
}
// 切断socket
-(void)cutOffSocket{
//    self.socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    [self.connectTimer invalidate];
    [self.socket disconnect];
}

-(void)onSocketDidDisconnect:(GCDAsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %@",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
    
}
-(void)onSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    [self.socket readDataWithTimeout:30 tag:0];
    
}
@end
