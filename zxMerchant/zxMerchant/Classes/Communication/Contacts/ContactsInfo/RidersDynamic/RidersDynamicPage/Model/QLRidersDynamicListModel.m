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
             };
}
@end

@implementation QLRidersDynamicFileModel

@end

