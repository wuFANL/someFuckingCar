//
//  MessageListModel.m
//  zxMerchant
//
//  Created by HK on 2021/5/4.
//  Copyright © 2021 ql. All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"info_list" : [MessageDetailModel class]};
}
@end

@implementation MessageDetailModel

@end


