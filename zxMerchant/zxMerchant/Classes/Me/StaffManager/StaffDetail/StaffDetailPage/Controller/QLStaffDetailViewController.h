//
//  QLStaffDetailViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,StaffInviteStatus) {
    UnknownInviteStatus,
    WaitStaffAgreen,
    WaitStoreAgreen,
    InviteSuccess,
    InviteFail
};
@interface QLStaffDetailViewController : QLBaseTableViewController
/**
 *邀请状态
 */
@property (nonatomic, assign) StaffInviteStatus status;

/** 员工信息*/
@property (nonatomic, strong) NSDictionary *empInfo;
@end

NS_ASSUME_NONNULL_END
