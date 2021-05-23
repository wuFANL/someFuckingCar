//
//  QLPhotosShareViewController.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/7/29.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLViewController.h"
#import "QLVehicleSortView.h"
#import "QLVehicleConditionsView.h"
#import "QLCarPhotosCell.h"
#import "QLChooseBrandViewController.h"
#import "QLShareImgViewController.h"
#import "QLVehiclePageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLPhotosShareViewController : QLViewController
/**
 *提交按钮
 */
@property (nonatomic, weak) UIButton *submitBtn;
/**
 *列表
 */
@property (nonatomic, strong) QLBaseTableView *tableView;
/**
 *数据
 */
@property (nonatomic, strong) QLVehiclePageModel *model;
/**
 *列表数据
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *选择数据
 */
@property (nonatomic, strong) NSMutableArray *chooseArr;
@end

NS_ASSUME_NONNULL_END
