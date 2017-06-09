//
//  XHSingleton.m
//  FlashMan
//
//  Created by 小河 on 17/3/23.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "XHSocketManager.h"
@interface XHSocketManager()<GCDAsyncSocketDelegate>
@end
@implementation XHSocketManager
+(XHSocketManager *) sharedInstance
{
    static XHSocketManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

// socket连接
-(void)socketConnectHost{
    dispatch_queue_t queue = dispatch_queue_create("com.test.xhsocket.setter", DISPATCH_QUEUE_SERIAL);
    //创建一个socket对象  代理方法都会在子线程调用，在刷新UI时就要回到主线程
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:queue socketQueue:nil];
    self.socket.IPv4PreferredOverIPv6 = NO; // 设置支持IPV6
    NSError *error = nil;
    // 链接服务器其实就是一句话的事情，就涵盖了socket链接时的三次握手，简单粗暴，
    //其中有一个超时时间,只有一种数值对他有效果，就是大于0的时候，这里设置成-1是没效果的，意思是如果给他一个链接超时时间，如果在这个时间内仍不能连上，则调用代理
#pragma mark ---使用GCDAsyncSocket就不用将C语言形式的输入输出流转换成OC对象了，因为已经帮我们封装好了---
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
}
//// 心跳连接
//-(void)longConnectToSocket{
//    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
//    NSString *longConnect = @"longConnect";
//    NSData *dataStream = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
//    [self.socket writeData:dataStream withTimeout:1 tag:1];
//}
// 切断socket
-(void)cutOffSocket{
//    self.socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    [self.connectTimer invalidate];
    [self.socket disconnect];
}

#pragma mark --当数据成功发送到服务器， 才会执行下面的代理方法---

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"数据成功发送到服务器");
    //，自己调用一下读取数据的方法, 发送数据成功后，接着_socket才会执行下面的方法,
    [_socket readDataWithTimeout:3 tag:tag];
}
//写入数据之后，同样，除了data是需要发送的数据外，也包含了两个值，超时时间和tag，这个超时时间一样，当到达超时时间后会调用这个代理
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    
    return elapsed;
}
#pragma mark ---GCDAsyncSocketDelegate---
//如果连接成功，我们会收到socket连接成功的回调，我们可以在这里做心跳的处理，或者token的验证等：
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"链接主机成功");
    //    // 每隔30s像服务器发送心跳包
    //    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    //    // 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    //    [self.connectTimer fire];
    
    //需要注意的是在链接成功的代理方法里面一定要写上如下的句子，否则是接收不到消息的，这个是读取消息用的
    NSString *logStr = @"iam:阿仁";
    NSData *requestData = [logStr dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:requestData withTimeout:3 tag:0];
    
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        NSLog(@"和主机断开链接");
    }
}

#pragma mark ---服务器有数据， 就会执行这个方法---
//接收到数据
//点击键盘发送按钮,发送消息数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    //将接收到的数据转换成字符串形式，在tableView中展示出来
//    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",dataString);
//    //刷新表格
//    if (tag == 102) {
//        //刷新UI
//        NSLog(@"发送的是键盘输入的消息数据");
//    } else if (tag == 101) {
//        NSLog(@"发送的是登录数据");
//    }
    if ([_xhSocketManageDelegate respondsToSelector:@selector(xhSocketManagerDidReadData:withTag:)]) {
        [_xhSocketManageDelegate xhSocketManagerDidReadData:data withTag:tag];
    }
    
}
//读数据超时之后凋用的方法
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    
    return elapsed;
}
@end
