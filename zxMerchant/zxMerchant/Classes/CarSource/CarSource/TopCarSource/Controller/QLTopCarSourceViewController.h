//
//  QLTopCarSourceViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLTopCarSourceViewController : QLBaseTableViewController
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)endRefresh;
@end

NS_ASSUME_NONNULL_END
