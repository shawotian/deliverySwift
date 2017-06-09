//
//  FMGuildViewController.m
//  FlashMan
//
//  Created by 小河 on 17/1/13.
//  Copyright © 2017年 taitanxiami. All rights reserved.
//

#import "FMGuildViewController.h"

@interface FMGuildViewController ()

@end

@implementation FMGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)prentViewController:(UIViewController*)vc
{
   
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
