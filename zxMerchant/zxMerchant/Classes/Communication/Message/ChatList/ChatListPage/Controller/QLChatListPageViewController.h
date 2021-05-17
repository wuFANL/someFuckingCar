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
//车ID + 对方的ID
-(id)initWithCarID:(NSString*)carID messageToID:(NSString *)messageTo;
@end

NS_ASSUME_NONNULL_END
