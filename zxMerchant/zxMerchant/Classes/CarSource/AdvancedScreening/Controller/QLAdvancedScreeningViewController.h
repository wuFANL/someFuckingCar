//
//  QLAdvancedScreeningViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/28.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLAdvancedScreeningViewController : QLBaseTableViewController
/**
 *是否有选择城市
 */
@property (nonatomic,assign) BOOL showCity;
/**
 *是否是订阅
 */
@property (nonatomic,assign) BOOL isSubscription;

@end

NS_ASSUME_NONNULL_END
