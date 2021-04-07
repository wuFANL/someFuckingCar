//
//  QLCityListModel.m
//  luluzhuan
//
//  Created by 乔磊 on 2017/10/20.
//  Copyright © 2017年 NineZero. All rights reserved.
//

#import "QLCityListModel.h"

@implementation QLCityListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"region_list" : [QLRegionListModel class]};
}
@end
@implementation QLRegionListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"region_id"  : @"id"};
}
@end
