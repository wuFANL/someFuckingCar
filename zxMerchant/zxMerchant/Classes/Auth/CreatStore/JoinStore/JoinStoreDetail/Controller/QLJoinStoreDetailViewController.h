//
//  QLJoinStoreDetailViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2021/4/22.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JoinStoreStatus) {
    UnknownJoinStatus,
    WaitStoreAgreen,
    JoinSuccess,
    JoinFail
};
@interface QLJoinStoreDetailViewController : QLBaseTableViewController
/**
 *申请状态
 */
@property (nonatomic, assign) JoinStoreStatus status;
@end

NS_ASSUME_NONNULL_END
