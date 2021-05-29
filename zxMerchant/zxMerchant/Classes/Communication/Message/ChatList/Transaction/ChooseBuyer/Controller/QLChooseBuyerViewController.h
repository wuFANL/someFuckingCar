//
//  QLChooseBuyerViewController.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/18.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLContactsPageViewController.h"
#import "MyFriendsModel.h"

typedef void (^ChooseFriendBlock) (FriendDetailModel * _Nullable model);
NS_ASSUME_NONNULL_BEGIN
@interface QLChooseBuyerViewController : QLContactsPageViewController
@property (nonatomic, copy) ChooseFriendBlock cfBlock;
-(id)initFromCarManager:(BOOL)isFromCarManager;

@end

NS_ASSUME_NONNULL_END
