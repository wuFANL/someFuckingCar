//
//  QLCarDealersViewController.m
//  zxMerchant
//
//  Created by lei qiao on 2021/6/8.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLCarDealersViewController.h"

@interface QLCarDealersViewController ()

@end

@implementation QLCarDealersViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车商友";
    
    
}

@end
