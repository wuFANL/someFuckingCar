//
//  QLMyStoreViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/9/12.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLMyStoreViewController.h"

@interface QLMyStoreViewController ()

@end

@implementation QLMyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的店铺";
    self.loadURLStr = [NSString stringWithFormat:@"http://wx.zcars365.com/#/?merchant_id=%@",[QLUserInfoModel getLocalInfo].account.account_id];
}



@end
