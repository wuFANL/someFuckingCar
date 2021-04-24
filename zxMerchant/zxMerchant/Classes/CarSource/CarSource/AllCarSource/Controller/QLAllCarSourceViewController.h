//
//  QLAllCarSourceViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^AllCarSourcerefreshBlock)(NSUInteger currentPage);

@interface QLAllCarSourceViewController : QLBaseTableViewController
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 子页面需要刷新*/
@property (nonatomic, copy) AllCarSourcerefreshBlock refreshBlock;

- (void)endRefresh;
@end

NS_ASSUME_NONNULL_END
