//
//  QLVehicleWarnModel.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/7.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleWarnModel : NSObject
/**
 *库龄超期
 */
@property (nonatomic, strong) NSString *assets_warn;
/**
 *强制险到期
 */
@property (nonatomic, strong) NSString *insure_warn;
/**
 *年检到期
 */
@property (nonatomic, strong) NSString *mot_warn;
@end

NS_ASSUME_NONNULL_END
