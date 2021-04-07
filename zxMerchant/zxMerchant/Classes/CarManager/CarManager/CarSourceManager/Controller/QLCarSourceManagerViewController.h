//
//  QLCarSourceManagerViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCarSourceManagerViewController : QLBaseTableViewController
/**
 *类型
 *0/1：全部车源、我的车源
 *2：合作车源
 */
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
