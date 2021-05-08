//
//  QLEditPermissionViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2021/2/23.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PermissionBlock)(NSDictionary* param);
@interface QLEditPermissionViewController : QLBaseTableViewController
/** 选择职位代理*/
@property (nonatomic, strong) PermissionBlock block;
@end

NS_ASSUME_NONNULL_END
