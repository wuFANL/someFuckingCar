//
//  QLAddCarPageModel.m
//  zxMerchant
//
//  Created by wufan on 2021/6/25.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLAddCarPageModel.h"
#import "QLNetworkingManager.h"
@implementation QLAddCarPageModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentText = @"";
        self.nameArr = [NSMutableArray new];
        self.belongArr = [NSMutableArray new];
    }
    return self;
}

- (void )queryData :(NSDictionary *)param complet:(void(^)(BOOL result))complet{
    
    // 销售归属人
    WEAKSELF
    [QLNetworkingManager postWithUrl:BusinessPath params:param success:^(id response) {
        [MBProgressHUD immediatelyRemoveHUD];
        NSArray *dataArr = [[response objectForKey:@"result_info"] objectForKey:@"at_work_personnel_list"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            NSMutableArray* nameArr = [NSMutableArray array];
            for (NSDictionary* dic in dataArr) {
                [nameArr addObject:EncodeStringFromDic(dic, @"personnel_nickname")];
            }
            weakSelf.nameArr = nameArr.copy;
            weakSelf.belongArr=dataArr.copy;
            complet(YES);
            [MBProgressHUD showCustomLoading:nil];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:error.domain];
        complet(NO);
    }];
}


@end
