//
//  QLMsgModel.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/5.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLMsgModel.h"

@implementation QLMsgModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"msg_id":@"id"};
}
@end
