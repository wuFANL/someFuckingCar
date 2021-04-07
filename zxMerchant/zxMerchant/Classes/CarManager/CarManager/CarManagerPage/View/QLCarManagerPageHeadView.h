//
//  QLCarManagerPageHeadView.h
//  zxMerchant
//
//  Created by lei qiao on 2020/12/2.
//  Copyright © 2020 ql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLChooseHeadView.h"
#import "QLVehicleSortView.h"
#import "QLVehicleConditionResultView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLCarManagerPageHeadView : UIView
@property (weak, nonatomic) IBOutlet QLChooseHeadView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *carBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet QLVehicleSortView *sortView;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UIButton *shareListBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet QLVehicleConditionResultView *resultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultViewHeight;

/**
 *显示选择结果层
 */
@property (nonatomic, assign) BOOL showResultView;
@end

NS_ASSUME_NONNULL_END
