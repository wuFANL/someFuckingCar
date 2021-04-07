//
//  QLCreatStoreViewController.h
//  PopularUsedCarMerchant
//
//  Created by lei qiao on 2020/9/21.
//  Copyright © 2020 EmbellishJiao. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCreatStoreViewController : QLBaseTableViewController
/**
 *账号编码
 */
@property (nonatomic, strong) NSString *account_id;
/**
 *返回到首页
 */
@property (nonatomic, assign) BOOL backToTab;
@end

NS_ASSUME_NONNULL_END
