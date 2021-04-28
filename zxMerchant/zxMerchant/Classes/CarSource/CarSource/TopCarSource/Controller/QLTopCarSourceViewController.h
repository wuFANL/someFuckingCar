//
//  QLTopCarSourceViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TopCarRefreshBlock)(NSUInteger page);
@interface QLTopCarSourceViewController : QLBaseTableViewController
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 刷新block*/
@property (nonatomic, copy)TopCarRefreshBlock refreshBlock;

- (void)endRefresh;
@end

NS_ASSUME_NONNULL_END
