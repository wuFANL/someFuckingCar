//
//  QLVehiclePageModel.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/7.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVehiclePageModel : NSObject
/**
 *车辆列表
 */
@property (nonatomic, strong) NSArray *car_list;
/**
 *车辆数量
 */
@property (nonatomic, strong) NSString *car_num;

@end

NS_ASSUME_NONNULL_END
