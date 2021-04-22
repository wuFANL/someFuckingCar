//
//  QLAddCarPageViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/4/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddCarPageViewController.h"

@interface QLAddCarPageViewController ()

@end

@implementation QLAddCarPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增车辆";
    
}



@end
