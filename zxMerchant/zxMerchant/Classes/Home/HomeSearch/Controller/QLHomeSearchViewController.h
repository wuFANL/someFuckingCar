//
//  QLHomeSearchViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/8.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"
typedef NS_ENUM(NSInteger,SearchType) {
    SearchCar = 0,
    SearchBrand = 1,
};
NS_ASSUME_NONNULL_BEGIN

@interface QLHomeSearchViewController : QLViewController
/**
 *搜索类型
 */
@property (nonatomic, assign) SearchType searchType;


@end

NS_ASSUME_NONNULL_END
