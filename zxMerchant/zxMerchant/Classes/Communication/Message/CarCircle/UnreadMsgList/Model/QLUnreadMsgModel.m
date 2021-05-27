//
//  QLUnreadMsgModel.m
//  zxMerchant
//
//  Created by lei qiao on 2021/5/25.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLUnreadMsgModel.h"

@implementation QLUnreadMsgModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dynamic_response" : [QLDynamicMsgModel class],
             };
}

@end
@implementation QLDynamicMsgModel


@end

