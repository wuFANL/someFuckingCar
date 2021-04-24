//
//  QLContactsPageViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^NFirendHeaderBlock) (NSString *headerPath);
@interface QLContactsPageViewController : QLBaseTableViewController
@property (nonatomic, copy) NFirendHeaderBlock headerBlock;
@end

NS_ASSUME_NONNULL_END
