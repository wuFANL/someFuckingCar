//
//  QLChatListPageViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/4.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLBaseTableViewController.h"
#import "MessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLChatListPageViewController : QLBaseTableViewController
-(id)initWithMessageDetailModel:(MessageDetailModel *)detailModel;
@end

NS_ASSUME_NONNULL_END
