//
//  QLBrandModel.m
//  PopularUsedCarManagement
//
//  Created by 乔磊 on 2019/1/30.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBrandModel.h"

@implementation QLBrandModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"brand_list" : [QLBrandInfoModel class]};
}

@end

@implementation QLBrandInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"brand_id"  : @"id",
             };
}
@end

@implementation QLSeriesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"series_id"  : @"id",
             };
}
@end

@implementation QLTypeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"modelList" : [QLTypeInfoModel class]};
}


@end

@implementation QLTypeInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"model_id"  : @"id",
             };
}

@end
