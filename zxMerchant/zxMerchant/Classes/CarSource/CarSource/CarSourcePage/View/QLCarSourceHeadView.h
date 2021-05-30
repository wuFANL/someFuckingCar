//
//  QLCarSourceHeadView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/11/17.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLBannerView.h"
#import "QLChooseHeadView.h"
#import "QLVehicleSortView.h"
#import "QLVehicleConditionResultView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLCarSourceHeadView : UIView
@property (weak, nonatomic) IBOutlet UIView *bannerBjView;
@property (weak, nonatomic) IBOutlet QLChooseHeadView *typeView;
@property (weak, nonatomic) IBOutlet QLVehicleSortView *conditionView;
@property (weak, nonatomic) IBOutlet QLVehicleConditionResultView *conditionResultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionResultViewHeight;
@property (nonatomic, strong) QLBannerView *bannerView;
/**
 *显示选择结果层
 */
@property (nonatomic, assign) BOOL showResultView;
@end

NS_ASSUME_NONNULL_END
