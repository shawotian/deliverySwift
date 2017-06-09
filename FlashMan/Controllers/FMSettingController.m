//
//  FMSettingController.m
//  FlashMan
//
//  Created by dianda on 2017/1/12.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMSettingController.h"
#import "SMAboutMeController.h"
#import "FMContactMeController.h"
#import "FMLoginViewController.h"
@interface FMSettingController ()

@property (weak, nonatomic) IBOutlet UIView *aboutBgView;
@property (weak, nonatomic) IBOutlet UIView *contactBgView;

@end

@implementation FMSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.aboutBgView.layer.cornerRadius = 2.0f;
    self.aboutBgView.layer.masksToBounds = YES;
    
    self.contactBgView.layer.cornerRadius = 2.0f;
    self.contactBgView.layer.masksToBounds = YES;
    
    [self.logOutBtn addTarget:self action:@selector(logOutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)logOutBtnClicked
{
    //退出登录
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"退出登录成功！";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.0);
    } completionBlock:^{
        
        [HUD removeFromSuperview];
        
        [GVUserDefaults standardUserDefaults].phoneNum = @"";
        [self.navigationController popToRootViewControllerAnimated:NO];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"logOutSuccess" object:nil];
        
        //TOKEN 失效
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMLoginViewController" bundle:nil];
        FMLoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.type = FMLoginTypeLogin;
        REFrostedViewController *tabbarVc = (REFrostedViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [tabbarVc.childViewControllers[0] pushViewController:loginVC animated:YES];
    }];

    
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        SMAboutMeController *aboutMe = [[SMAboutMeController alloc]init];
        [self.navigationController pushViewController:aboutMe animated:YES];
    }else {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FMContactMeController" bundle:nil];
        FMContactMeController *contactMe = [sb instantiateViewControllerWithIdentifier:@"FMContactMeController"];        
        [self.navigationController pushViewController:contactMe animated:YES];
    }
}
@end
