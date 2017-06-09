//
//  SMAboutMeController.m
//  SaleMan
//
//  Created by dianda on 2016/10/26.
//  Copyright © 2016年 diandactc. All rights reserved.
//

#import "SMAboutMeController.h"

@interface SMAboutMeController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLable;

@end

@implementation SMAboutMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于";
    self.versionLable.text = [NSString stringWithFormat:@"猪行侠%@",[AppUtils getAPPVersion]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
