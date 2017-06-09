//
//  FMContactMeController.m
//  FlashMan
//
//  Created by dianda on 2017/1/19.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMContactMeController.h"

@interface FMContactMeController ()
@property (weak, nonatomic) IBOutlet UIView *aboutBgView;
@property (weak, nonatomic) IBOutlet UIView *contactBgView;
//电话
@property(nonatomic,strong)NSString *phoneStr;
//email
@property(nonatomic,strong)NSString *emailStr;

@end

@implementation FMContactMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联系客服";
    self.aboutBgView.layer.cornerRadius = 2.0f;
    self.aboutBgView.layer.masksToBounds = YES;
    
    self.contactBgView.layer.cornerRadius = 2.0f;
    self.contactBgView.layer.masksToBounds = YES;

    [self initData];
}

-(void)initData{
    NetRequestClass *request=[[NetRequestClass alloc]init];
    NSString *url=[NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,kCUSTOMSERVER];
    
    [AppUtils showWithStatus:nil];
    [request NetRequestGETWithRequestURL:url WithParameter:nil WithReturnValeuBlock:^(id returnValue) {
        [AppUtils dismissHUD];
        
        
        NSDictionary *data = returnValue[@"data"];
        _phoneStr = data[@"telephone"];
        _emailStr = data[@"email"];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_phoneStr];
        self.mailLabel.text = [NSString stringWithFormat:@"邮箱：%@",_emailStr];
        [self.tv reloadData];
        

        
    } WithErrorCodeBlock:^(id errorCode) {
        
        [XHView showTipHud:errorCode[@"message"] superView:self.view];
        [AppUtils dismissHUD];
        
        
    } WithFailureBlock:^{
        [AppUtils dismissHUD];
        
        
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要拨打电话联系客服" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *phoneNum = [NSString stringWithFormat:@"tel://%@",_phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
//        UIAlertAction *Destructive = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            NSLog(@"Destructive");
//        }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
//        [alert addAction:Destructive];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        NSMutableString *mailUrl = [[NSMutableString alloc] init];
        
        NSArray *toRecipients = @[_emailStr];
        // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
        [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
        [mailUrl appendString:@"&subject=反馈问题"];
        NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
