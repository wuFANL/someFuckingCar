//
//  QLCarInfoModel.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2018/10/6.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLCarInfoModel.h"
#import "QLCarDetailModel.h"
@implementation QLCarInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"car_id" : @[@"id",@"car_id"],
             @"sell_real_price" : @[@"seller_real_price",@"sell_real_price"],
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"att_list" : [QLCarBannerModel class],
             };
}
@end
