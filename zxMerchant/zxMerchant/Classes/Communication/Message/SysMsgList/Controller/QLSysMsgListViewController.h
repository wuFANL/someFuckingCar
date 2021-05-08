//
//  QLSysMsgListViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/10/11.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLSysMsgListViewController : QLBaseTableViewController
-(id)initWithTitle:(NSString *)titleStr;
/**
 *分组名
 */
@property (nonatomic, strong) NSString *groupTitle;

@end

NS_ASSUME_NONNULL_END
