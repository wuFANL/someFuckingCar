//
//  QLCarSourceDetailViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/26.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLCarSourceDetailViewController : QLBaseTableViewController
//如果从聊天详情进入 则底部右侧按钮功能变为打电话 change by hk
@property (nonatomic, assign) BOOL isFromChat;

- (void)updateVcWithData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
