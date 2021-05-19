//
//  QLVehiclePageModel.m
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/7.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLVehiclePageModel.h"
#import "QLCarInfoModel.h"
@implementation QLVehiclePageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"car_list" : [QLCarInfoModel class],
            };
}
@end
