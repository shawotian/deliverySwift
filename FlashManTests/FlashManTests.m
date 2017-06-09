//
//  FlashManTests.m
//  FlashManTests
//
//  Created by taitanxiami on 2017/1/4.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//尽量让代码低耦合高内聚，利于单元测试

#import <XCTest/XCTest.h>
#import "AFNetworking.h"
#import <STAlertView/STAlertView.h>

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:10 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface FlashManTests : XCTestCase
@property (nonatomic, strong) STAlertView *stAlertView;
@end

@implementation FlashManTests
//会在每一个测试用例开始前调用，用来初始化相关数据；
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
//在测试用例完成后调用，可以用来释放变量等结尾操作；
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//用来执行我们需要的测试操作，正常情况下，我们不使用这个方法，而是创建名为test+测试目的的方法来完成我们需要的操作：
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog(@"自定义测试testExample");
    int  a= 3;
    XCTAssertTrue(a == 3,"a 不能等于 0");
}
-(void)testRequest{
    NSLog(@"主线程1");
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    // 2.发送GET请求
    [mgr GET:@"http://www.weather.com.cn/adat/sk/101110101.html" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        XCTAssertNotNil(responseObject, @"返回出错");
        self.stAlertView = [[STAlertView alloc]initWithTitle:@"验证码" message:nil textFieldHint:@"请输入手机验证码" textFieldValue:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelButtonBlock:^{
            //点击取消返回后执行
            [self testAlertViewCancel];
            NOTIFY //继续执行
        } otherButtonBlock:^(NSString *b) {
            //点击确定后执行
            [self alertViewComfirm:b];
            NOTIFY //继续执行
        }];
        [self.stAlertView show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        XCTAssertNil(error, @"请求出错");
        NOTIFY //继续执行
    }];
    NSLog(@"主线程2");
//    WAIT  //暂停
    NSLog(@"主线程3");

}

//会将方法中的block代码耗费时长打印出来；
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testAlertViewCancel{
    NSLog(@"取消");
}
-(void)testAlertViewComfirm{
    [self alertViewComfirm:nil];
}
-(void)alertViewComfirm:(NSString *)test{
    NSLog(@"手机验证码:%@",test);
}


@end
