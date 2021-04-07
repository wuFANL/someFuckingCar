//
//  QLAgreementDetailViewController.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/11/1.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLAgreementDetailViewController.h"
#import "QLHomePageModel.h"
@interface QLAgreementDetailViewController ()
@property (nonatomic, strong) NSArray *news_list;

@end

@implementation QLAgreementDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.naviTitle;
    //内容请求
    [self getContentRequest];
}
#pragma mark -network
//内容请求
- (void)getContentRequest {
    [MBProgressHUD showCustomLoading:nil];
    [QLNetworkingManager postWithParams:@{@"operation_type":@"get_news_list",@"type":@"5",@"sub_type":QLNONull(self.serialNum)} success:^(id response) {
        self.news_list = [NSArray yy_modelArrayWithClass:[QLBannerModel class] json:response[@"result_info"][@"news_list"]];
        if (self.news_list.count != 0) {
            QLBannerModel *model = self.news_list.firstObject;
            self.loadURLStr = model.news_content;
        } else {
            [MBProgressHUD showError:@"数据为空"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
    }];
}
#pragma mark - Lazy
- (NSArray *)news_list {
    if (!_news_list) {
        _news_list = [NSArray array];
    }
    return _news_list;
}

@end
