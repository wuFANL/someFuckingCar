//
//  QLCarDetailModel.m
//  PopularUsedCar
//
//  Created by 乔磊 on 2018/7/2.
//  Copyright © 2018年 EmbellishJiao. All rights reserved.
//

#import "QLCarDetailModel.h"
#import "QLHomePageModel.h"
@implementation QLCarDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"car_img_banner_list" : [QLCarBannerModel class],
             @"car_img_banner_list" : [QLCarBannerModel class],
             @"car_img_exterior_list" : [QLCarBannerModel class],
             @"car_img_engine_list" : [QLCarBannerModel class],
             @"car_img_trim_list" : [QLCarBannerModel class],
             @"car_img_other_list" : [QLCarBannerModel class],
             @"examine_info" : [QLExamineInfoModel class],
             @"common_problem_list" : [QLBannerModel class],
             @"guess_you_like_list" : [QLCarInfoModel class],
             @"describe_list" : [QLDescribeModel class]
             };
}
@end

@implementation QLCarBannerModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"banner_id"  : @[@"id",@"banner_id"]
             };
}
@end

@implementation QLExamineInfoModel

@end

@implementation QLDescribeModel

@end

@implementation QLStaffInfoModel

@end
