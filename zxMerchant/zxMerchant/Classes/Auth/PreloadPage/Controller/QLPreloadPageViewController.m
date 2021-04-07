//
//  QLPreloadPageViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/5/27.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLPreloadPageViewController.h"

@interface QLPreloadPageViewController ()

@end

@implementation QLPreloadPageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //功能数据
    [self getFunData];
    //预加载个人信息
    [self getMeInfo];
}
//功能数据
- (void)getFunData {
    [[QLToolsManager share] getFunData:^(id result, NSError *error) {
        if (!error) {
            [AppDelegateShare initTabBarVC];
        } else {
            if([error.domain containsString:@"商户异常"]||[error.domain containsString:@"重新登陆"]) {
                [QLUserInfoModel loginOut];
                [AppDelegateShare initLoginVC];
            } else {
                QLCustomAlertView *alertView = [[QLToolsManager share] alert:@"数据获取失败" handler:^(NSError *error) {
                    if (!error) {
                        if (!error) {
                            //重新获取
                           [self getFunData];
                        }
                    }
                }];
                [alertView.confirmBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            }
        }
    }];
}
//个人信息
- (void)getMeInfo {
    [[QLToolsManager share] getMeInfoRequest:^(id result, NSError *error) {
        
    }];
    
}


@end
