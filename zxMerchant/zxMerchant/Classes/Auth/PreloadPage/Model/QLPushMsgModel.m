//
//  QLPushMsgModel.m
//  zxMerchant
//
//  Created by lei qiao on 2020/9/27.
//  Copyright © 2020 ql. All rights reserved.
//

#import "QLPushMsgModel.h"

@implementation QLPushMsgModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"msg_id":@"id"};
}

@end
