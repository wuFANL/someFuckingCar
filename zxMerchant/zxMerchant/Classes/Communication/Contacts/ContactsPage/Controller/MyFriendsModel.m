//
//  MyFriendsModel.m
//  zxMerchant
//
//  Created by HK on 2021/4/27.
//  Copyright © 2021 ql. All rights reserved.
//

#import "MyFriendsModel.h"

@implementation MyFriendsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"account_list" : [FriendDetailModel class]};
}
@end

@implementation FriendDetailModel

@end
