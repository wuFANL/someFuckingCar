//
//  QLVehicleConditionsView.h
//  PopularUsedCarMerchant
//
//  Created by 乔磊 on 2019/4/9.
//  Copyright © 2019 EmbellishJiao. All rights reserved.
//

#import "QLBaseView.h"
#import "QLBrandModel.h"
#import "QLVehicleWarnModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLVehicleConditionsView : QLBaseView
//是否显示
@property (nonatomic, assign) BOOL isShow;

/**
 *位置偏移
 */
@property (nonatomic, assign) CGFloat offY;
/**
 *选择类型
 *0:智能排序 1:价格排序选项 2：状态排序 3：车辆筛选 4:征信查询筛选
 */
@property (nonatomic, assign) NSInteger type;
/**
 *智能排序选项
 */
@property (nonatomic, copy) NSArray *sort_byArr;
/**
 *价格排序选项
 */
@property (nonatomic, copy) NSArray *priceRangeArr;
/**
 *状态排序选项
 */
@property (nonatomic, copy) NSArray *deal_stateArr;
/**
 *排序
 */
@property (nonatomic, assign) NSInteger sort_by;
/**
 *价格区间
 */
@property (nonatomic, strong) NSString *priceRange;
/**
 *状态
 */
@property (nonatomic, assign) NSInteger deal_state;
/**
 *品牌
 */
@property (nonatomic, strong) QLBrandInfoModel * __nullable brandModel;
/**
 *车系
 */
@property (nonatomic, strong) QLSeriesModel * __nullable seriesModel;
/**
 *车型
 */
@property (nonatomic, strong) QLTypeInfoModel * __nullable typeModel;
/*
 *选中分区
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/**
 *数据
 */
@property (nonatomic, strong) QLVehicleWarnModel *warnModel;
/**
 *结果返回
 */
@property (nonatomic, strong) resultBackBlock handler;
//清除选择的row
- (void )clearSeletRow;


/*
 *显示
 */
- (void)show;
/*
 *隐藏
 */
- (void)hidden;
- (void)hiddenViewEvent;
@end

NS_ASSUME_NONNULL_END
