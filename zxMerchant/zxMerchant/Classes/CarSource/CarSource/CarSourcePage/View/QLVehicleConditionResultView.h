//
//  QLVehicleConditionResultView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/24.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleConditionResultView : UIView
/**
 *数据
 */
@property (nonatomic, strong) NSArray * __nullable itemArr;
/**
 *数据变化回调
 */
@property (nonatomic, strong) resultBackBlock dataHandler;
@end

NS_ASSUME_NONNULL_END
