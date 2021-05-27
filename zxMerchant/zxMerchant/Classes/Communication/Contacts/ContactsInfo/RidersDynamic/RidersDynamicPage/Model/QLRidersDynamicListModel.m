//
//  QLRidersDynamicListModel.m
//  zxMerchant
//
//  Created by lei qiao on 2021/5/5.
//  Copyright © 2021 ql. All rights reserved.
//

#import "QLRidersDynamicListModel.h"

@implementation QLRidersDynamicListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"file_array" : [QLRidersDynamicFileModel class],
             @"praise_list" : [QLRidersDynamicPraiseModel class],
             @"interact_list" : [QLRidersDynamicInteractModel class],
             };
}
- (NSArray *)praise_list {
    if (!_praise_list) {
        _praise_list = [NSArray array];
    }
    return _praise_list;
}
- (NSArray *)interact_list {
    if (!_interact_list) {
        _interact_list = [NSArray array];
    }
    return _interact_list;
}
@end

@implementation QLRidersDynamicFileModel

@end

@implementation QLRidersDynamicInteractModel

@end

@implementation QLRidersDynamicPraiseModel

@end



